function [A, out] = python_ipc_sysoneline(what, cmd, mktmpfile, varargin)
% "out" is provided for debugging

  persistent show_msg

  if (strcmp(what, 'reset'))
    show_msg = [];
    A = true;
    out = [];
    return
  end

  if ~(strcmp(what, 'run'))
    error('unsupported command')
  end

  vstr = sympref('version');

  if (isempty(show_msg))
    disp(['OctSymPy v' vstr ': this is free software without warranty, see source.'])
    disp('Using system()-based communication with Python [sysoneline].')
    disp('Warning: this will be *SLOW*.  Every round-trip involves executing a')
    disp('new Python process and many operations involve several round-trips.')
    show_msg = true;
  end

  newl = sprintf('\n');

  %% Headers
  % embedding the headers in the -c command is too long for
  % Windows.  We have a 8000 char budget, and the header uses all
  % of it.  This looks fragile w.r.t. pwd...  investigate.
  headers = ['execfile(\"private/python_header.py\");'];
  %s = python_header_embed2();
  %headers = ['exec(\"' s '\"); '];


  %% load all the inputs into python as pickles
  s = python_copy_vars_to('_ins', true, varargin{:});
  % extra escaping
  s = myesc(s);
  % join all the cell arrays with escaped newline
  s = mystrjoin(s, '\n');
  s1 = ['exec(\"' s '\"); '];


  %% The actual command
  % cmd will be a snippet of python code that does something
  % with _ins and produce _outs.
  s = python_format_cmd(cmd);
  s = myesc(s);
  s = mystrjoin(s, '\n');
  s2 = ['exec(\"' s '\"); '];


  %% output, or perhaps a thrown error
  s = python_copy_vars_from('_outs');
  s = myesc(s);
  s = mystrjoin(s, '\n');
  s3 = ['exec(\"' s '\");'];

  pyexec = sympref('python');
  if (isempty(pyexec))
    pyexec = 'python';
  end

  if (~mktmpfile)
    %% paste all the commands into the system() command line
    % python -c
    bigs = [headers s1 s2 s3];
    [status,out] = system([pyexec ' -c "' bigs '"']);
  else
    %% Generate a temp shell script then execute it with system()
    % This is for debugging ipc; not intended for general use
    fname = 'tmp_python_cmd.sh';
    fd = fopen(fname, 'w');
    fprintf(fd, '#!/bin/sh\n\n');
    fprintf(fd, '# temporary autogenerated code\n\n');
    fputs(fd, [pyexec ' -c "']);
    fputs(fd, headers);
    fputs(fd, s1);
    fputs(fd, s2);
    fputs(fd, s3);
    fputs(fd, '"');
    fclose(fd);
    [status,out] = system(['sh ' fname]);
  end

  if status ~= 0
    status
    out
    error('system() call failed!');
  end

  % there should be two blocks
  ind = strfind(out, '<output_block>');
  assert(length(ind) == 2)
  out1 = out(ind(1):(ind(2)-1));
  % could extractblock here, but just search for keyword instead
  if (isempty(strfind(out1, 'successful')))
    error('failed to import variables to python?')
  end
  A = extractblock(out(ind(2):end));
end


function s = myesc(s)

  for i = 1:length(s)
    % order is important here

    % escape quotes twice
    s{i} = strrep(s{i}, '\', '\\\\');

    % dbl-quote is rather special here
    % /" -> ///////" -> ///" -> /" -> "
    s{i} = strrep(s{i}, '"', '\\\"');

  end
end

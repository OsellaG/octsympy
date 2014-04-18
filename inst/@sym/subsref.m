function out = subsref (f, idx)
%SUBSREF  Access entries of a symbolic array

  %disp('call to @sym/subsref')
  switch idx.type
    case '()'
      if (isa(idx.subs, 'sym'))
        error('todo: indexing by @sym, can this happen? what is subindex for then?')
      else
        out = mat_access2(f,idx.subs);
      end
    case '.'
      fld = idx.subs;
      if (strcmp (fld, 'pickle'))
        out = f.pickle;
      elseif (strcmp (fld, 'text'))
        out = f.text;
      elseif (strcmp (fld, 'flattext'))
        out = f.flattext;
      % not part of the interface
      %elseif (strcmp (fld, 'size'))
      %  out = f.size;
      %elseif (strcmp (fld, 'extra'))
      %  out = f.extra;
      else
        error ('@sym/subsref: invalid property ''%s''', fld);
      end

    otherwise
      error ('@sym/subsref: invalid subscript type ''%s''', idx.type);

  end



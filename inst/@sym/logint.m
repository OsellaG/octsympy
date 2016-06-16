%% Copyright (C) 2016 Colin B. Macdonald
%%
%% This file is part of OctSymPy.
%%
%% OctSymPy is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 3 of the License,
%% or (at your option) any later version.
%%
%% This software is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty
%% of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
%% the GNU General Public License for more details.
%%
%% You should have received a copy of the GNU General Public
%% License along with this software; see the file COPYING.
%% If not, see <http://www.gnu.org/licenses/>.

%% -*- texinfo -*-
%% @documentencoding UTF-8
%% @defmethod @@sym logint (@var{x})
%% Symbolic logint function.
%%
%% Example:
%% @example
%% @group
%% syms x
%% y = logint (x)
%%   @result{} y = (sym) li(x)
%% @end group
%% @end example
%%
%% Note: this file is autogenerated: if you want to edit it, you might
%% want to make changes to 'generate_functions.py' instead.
%%
%% @end defmethod


function y = logint(x)
  if (nargin ~= 1)
    print_usage ();
  end
  y = uniop_helper (x, 'li');
end


%!error <Invalid> logint (sym(1), 2)

%!shared x, d
%! d = 2;
%! x = sym('2');

%!test
%! f1 = logint(x);
%! f2 = 1.045163780117492784845;
%! assert( abs(double(f1) - f2) < 1e-15 )

%!test
%! D = [d d; d d];
%! A = [x x; x x];
%! f1 = logint(A);
%! f2 = 1.045163780117492784845;
%! f2 = [f2 f2; f2 f2];
%! assert( all(all( abs(double(f1) - f2) < 1e-15 )))

%!test
%! % round trip
%! % https://github.com/sympy/sympy/pull/11219
%! if (python_cmd ('return Version(spver) > Version("1.0")'))
%! y = sym('y');
%! A = logint (d);
%! f = logint (y);
%! h = function_handle (f);
%! B = h (d);
%! assert (A, B, -eps)
%! end

%% Copyright (C) 2014-2016 Colin B. Macdonald
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
%% @defmethod @@sym gamma (@var{x})
%% Symbolic gamma function.
%%
%% Example:
%% @example
%% @group
%% syms x
%% y = gamma (x)
%%   @result{} y = (sym) Γ(x)
%% @end group
%% @end example
%%
%% Note: this file is autogenerated: if you want to edit it, you might
%% want to make changes to 'generate_functions.py' instead.
%%
%% @end defmethod


function y = gamma(x)
  if (nargin ~= 1)
    print_usage ();
  end
  y = uniop_helper (x, 'gamma');
end


%!error <Invalid> gamma (sym(1), 2)
%!assert (isequaln (gamma (sym(nan)), sym(nan)))

%!shared x, d
%! d = 1;
%! x = sym('1');

%!test
%! f1 = gamma(x);
%! f2 = gamma(d);
%! assert( abs(double(f1) - f2) < 1e-15 )

%!test
%! D = [d d; d d];
%! A = [x x; x x];
%! f1 = gamma(A);
%! f2 = gamma(D);
%! assert( all(all( abs(double(f1) - f2) < 1e-15 )))

%!test
%! % round trip
%! y = sym('y');
%! A = gamma (d);
%! f = gamma (y);
%! h = function_handle (f);
%! B = h (d);
%! assert (A, B, -eps)

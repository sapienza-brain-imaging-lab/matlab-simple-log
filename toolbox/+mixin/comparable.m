classdef (Abstract, HandleCompatible) comparable
	methods (Access = public, Sealed)
		function v = isequal(this, that)
			v = isa(this, 'mixin.comparable') && isa(that, 'mixin.comparable') ...
				&& strcmp(class(this), class(that)) ...
				&& isequal(size(this), size(that)) ...
				&& all(compareObjects(this(:), that(:)));
		end
		
		function v = isequaln(this, that)
			v = isa(this, 'mixin.comparable') && isa(that, 'mixin.comparable') ...
				&& strcmp(class(this), class(that)) ...
				&& isequal(size(this), size(that)) ...
				&& all(compareObjects(this(:), that(:)));
		end
		
		function v = eq (this, that)
			sthis = isscalar(this);
			sthat = isscalar(that);
			if sthis && ~sthat
				this = repmat(this, size(that));
			elseif sthat && ~sthis
				that = repmat(that, size(this));
			elseif ~isequal(size(this), size(that))
				throwAsCaller(MException('MATLAB:dimagree', 'Matrix dimensions must agree.'));
			end
			if strcmp(class(this), class(that))
				v = compareObjects(that, this);
			else
				v = false(size(this));
			end
		end

		function v = ne (this, that)
			v = ~eq(this, that);
		end

		function [a,b] = ismember (this, array, varargin) %#ok<VANUS>
			b = arrayfun(@findin, this);
			a = b ~= 0;
			
			function y = findin (x)
				y = find(x == array, 1);
				if isempty(y)
					y = 0;
				end
			end
		end

		function [a,b,c] = unique (this, arg)
			arguments
				this(1,:)	mixin.comparable
			end
			
			arguments (Repeating)
				arg
			end

			if isempty(this)
				a = this;
				b = [];
				c = [];
			else
				[b,c] = uniqueObjects(this, arg{:});
				a = this(b);
			end
		end
	end
	
	methods (Access = protected)
		function e = compareObjects (this, that)
			e = true(size(this));
			if isempty(e), return; end

			p = getComparableProperties(this);
			for i=1:length(p)
				e(e) = cellfun(@isequaln, {this(e).(p{i})}, {that(e).(p{i})});
				if ~any(e)
					return;
				end
			end
		end

		function p = getComparableProperties (this)
			p = fieldnames(this);
		end

		function [b,c] = uniqueObjects (this, varargin)
			getLast = any(strcmp(varargin, 'last'));
			a = this(1);
			b = 1;
			c = ones(size(this));
			n = 1;
			for i=2:length(c)
				j = find(compareObjects(repmat(this(i), 1, n), a));
				if isempty(j)
					n = n + 1;
					a(n) = this(i);
					b(n) = i; %#ok<AGROW>
					c(i) = n;
				else
					c(i) = j;
					if getLast
						b(j) = i; %#ok<AGROW>
					end
				end
			end
		end
	end
end

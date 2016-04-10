function s=parse_string_name(input_string,inputs_names)
s=input_string;
for j=1:length(inputs_names)
s = strrep(s, sprintf('u{%i}',j), inputs_names(j));
end


[at]=findstr('@(', s);
[close_p]=findstr(')', s);
if ~isempty(at)
    s(at:close_p(1))=[];
end
[pos]=findstr(')^0', s);
[parentesis_pos]=findstr('(', s);
del=[];
for i=1:length(pos)
    
    first(i)=max(parentesis_pos(parentesis_pos<pos(i)))-1;
    last(i)=pos(i)+2;
    del=[del,first(i):last(i)];
end
size(del)
size(s)
s(del)=[];
s = strrep(s, '^1', '');
s = strrep(s, 't-0', 't');
for  x=1:5
s = strrep(s, '**', '');
if isempty(findstr('(',s))
    s='1';
end
if s(1)=='*'
    s(1)=[];
end

if s(end)=='*'
    s(end)=[];
end
end
end
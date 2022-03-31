function cleaned = SNLP_findReplace(raw, findandreplace)

cleaned=raw;

for i=1:size(findandreplace,1)
cleaned = regexprep(cleaned,strcat({' '},findandreplace{i,1},{' '}),strcat({' '},findandreplace{i,2},{' '}));
end

end

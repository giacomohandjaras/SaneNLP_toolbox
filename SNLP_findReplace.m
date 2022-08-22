function text_out = SNLP_findReplace(text_in, findandreplace);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Find and replace words in a text
%%%%
%%%%Usage:
%%%%	text_out = SNLP_findReplace(text_in, findandreplace)
%%%%
%%%%	text_in: a string of text (in UTF-8)
%%%%	findandreplace: a cell matrix (R x 2) containing words to find in the first column and their replacement in the second column
%%%%
%%%%	text_out: the text with the substituted words
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cleaned=raw;

for i=1:size(findandreplace,1)
    cleaned = regexprep(cleaned,strcat({' '},findandreplace{i,1},{' '}),strcat({' '},findandreplace{i,2},{' '}));
end

end

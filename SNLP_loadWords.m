function [words]=SNLP_loadWords(filename);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Open a set of words of interest from a TXT file
%%%%
%%%%Usage:
%%%%	[words]=SNLP_loadWords(filename)
%%%%
%%%%	filename: the UTF-8 TXT file to be loaded. Words could be separated by TAB chars
%%%%
%%%%	words: a cell matrix containing the loaded words
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

small_file=0;
str = extractFileText(filename,'Encoding', 'UTF-8');
words = split(str,newline);
words = SNLP_removeShortLines(words,0);
if numel(words)==1
    small_file=1;
end

words = split(words,char([9]));

if small_file==1
    words=words';
end

end

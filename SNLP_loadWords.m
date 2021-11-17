function [customStopWords]=SNLP_loadWords(filename);

small_file=0;
str = extractFileText(filename,'Encoding', 'UTF-8');
customStopWords = split(str,newline);
customStopWords = SNLP_removeShortLines(customStopWords,0);
if numel(customStopWords)==1
small_file=1;
end

customStopWords = split(customStopWords,char([9]));

if small_file==1
customStopWords=customStopWords';
end

end

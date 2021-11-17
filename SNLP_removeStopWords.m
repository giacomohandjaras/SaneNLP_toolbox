function [textDataOut]=SNLP_removeStopWords(textDataIn,customStopWords);

textDataOut="";

strn = strsplit(textDataIn,' ','CollapseDelimiters',true);
words=numel(strn);

for word=1:words
strn_w=strn(word);
if strlength(strn_w)>1
if SNLP_isStopWord(strn_w,customStopWords)==0 
textDataOut=strcat(textDataOut,{' '},strn_w);
end
end
end

end

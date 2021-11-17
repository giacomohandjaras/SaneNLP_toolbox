function [textDataOut]=SNLP_getUniqueWords(textDataIn);

textDataOut="";

strn = strsplit(textDataIn,' ','CollapseDelimiters',true);
strn=unique(strn);

words=numel(strn);
for word=1:words
strn_w=strn(word);
if strlength(strn_w)>1
textDataOut=strcat(textDataOut,{' '},strn_w);
end
end


end

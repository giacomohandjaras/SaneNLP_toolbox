function [textDataOut]=SNLP_removeShortLines(textDataIn,k);

textDataIn_mask=zeros(numel(textDataIn),1);
lines=numel(textDataIn);

for line=1:lines
strn=textDataIn(line);
if strlength(strn)<=k
textDataIn_mask(line)=1;
end
end

textDataIn(textDataIn_mask>0)=[];
textDataOut=textDataIn;
end

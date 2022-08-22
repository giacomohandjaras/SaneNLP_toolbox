function SNLP_saveWords(filename,words);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Given a set of words of interest, write them to disk in a CSV file
%%%%
%%%%Usage:
%%%%	SNLP_saveWords(filename,words)
%%%%
%%%%	filename: the file CSV to be saved
%%%%	words: a cell matrix (R x C) containing the words that must be saved
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lines=size(words,1);
columns=size(words,2);

fid = fopen(filename,'wt');

for l=1:lines
    str=string(words{l,1});
    
    for c=2:columns
        str=strcat(str,',',string(words{l,c}));
    end
    
    if strlength(str)>0
        fprintf(fid, '%s\n',str);
    end
    
end
fclose(fid);

end

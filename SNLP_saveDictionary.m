function SNLP_saveDictionary(filename,words,occurrences);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Given a set of words of interest and their occurrences, write them to disk in a dictionary TXT file with the same encoding of Word2Vec
%%%%
%%%%Usage:
%%%%	SNLP_saveDictionary(filename,words,occurrences)
%%%%
%%%%	filename: the dictionary TXT file to be saved (in UTF-8 encoding, see Word2Vec specifications)
%%%%	words: a cell matrix (R x 1) containing the words that must be saved
%%%%	occurrences: a numerical matrix (R x 1) containing the occurrences of each word
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lines=numel(words);
fid = fopen(filename,'wt','n','UTF-8');
starting_pos=1;

word=string(words{1});
if (strcmp(word,'</s>')==0)
    word="</s>";
    occ=num2str([0]);
    str=strcat(word,string(char(32)),occ);
    fprintf(fid, '%s\n',str);
end

for l=1:lines
    word=string(words{l});
    word=regexprep(word,' ','');
    occ=num2str(occurrences(l));
    str=strcat(word,string(char(32)),occ);
    
    if strlength(str)>1
        fprintf(fid, '%s\n',str);
    end
    
end
fclose(fid);

end

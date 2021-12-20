function SNLP_saveDictionary(filename,wordlist,occurrences);

lines=numel(wordlist);
fid = fopen(filename,'wt','n','UTF-8');
starting_pos=1;

word=string(wordlist{1});
if (strcmp(word,'</s>')==0)
word="</s>";
occ=num2str([0]);
str=strcat(word,string(char(32)),occ);
fprintf(fid, '%s\n',str);
end

for l=1:lines
 word=string(wordlist{l});
 word=regexprep(word,' ','');
 occ=num2str(occurrences(l));
 str=strcat(word,string(char(32)),occ);

 if strlength(str)>1
 fprintf(fid, '%s\n',str);
 end
 
end
 fclose(fid);
	
end

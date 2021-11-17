function SNLP_convertW2VtoMAT(filename_root,columns,language)

ITA=0;
ENG=0;
stemming=0;

lang=lower(language);
if(strcmp(lang,'ita'))
ITA=1;
ENG=0;
stemming=1;
end
if(strcmp(lang,'eng'))
ITA=0;
ENG=1;
stemming=1;
end



filename=[filename_root,'.bin'];
disp(sprintf('Apriamo il file di word2vec %s con %d colonne...',filename,columns));

vectors=read_mixed_csv(filename," ");

%%%%passiamo da testo a numeri

disp(sprintf('Estraiamo i vettori...'));

num_words=size(vectors,1)-1;
wordlist={};
vectors_matrix=nan(num_words,columns);

for i=2:size(vectors,1)
wordlist{i-1}=vectors{i,1};
for j=1:columns
temp=vectors{i,j+1};
if(length(temp)>0)
vectors_matrix((i-1),j)=str2num(temp);
end
end
end

clear vectors

if stemming==1
disp(sprintf('Stemmiamo in %s in anticipo...',lang));
wordlist_stem=cell(size(wordlist));
for i=1:num_words

if ITA==1
wordlist_stem{i}=SNLP_stemming_ita(wordlist{i});
end
if ENG==1
wordlist_stem{i}=SNLP_stemming_eng(wordlist{i});
end

end
end


filename_mat=[filename_root,'.mat'];
disp(sprintf('Salviamo i vettori in %s...',filename_mat));

if stemming==1
save(filename_mat,'vectors_matrix','wordlist_stem','wordlist','num_words','filename_root','-v7.3');
else
save(filename_mat,'vectors_matrix','wordlist','num_words','filename_root','-v7.3');
end

end

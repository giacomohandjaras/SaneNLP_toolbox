function wordvectors_extracted=SNLP_getWordVectors(words, vocabulary, wordvectors)

num_of_stim=numel(words);
columns=size(wordvectors,2);

wordvectors_extracted=nan(num_of_stim,columns);

for i=1:num_of_stim
position=find(strcmp(vocabulary,words(i)));
if numel(position)>0
wordvectors_extracted(i,:)=wordvectors(position(1),:);
end
end

end

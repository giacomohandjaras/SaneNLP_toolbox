function wordvectors_extracted=SNLP_getWordVectorsSmoothed(words, vocabulary, wordvectors, words_stem, vocabulary_stem, smooth)

num_of_stim=numel(words);
columns=size(wordvectors,2);

wordvectors_extracted=nan(num_of_stim,columns);

for i=1:num_of_stim
position_unique=find(strcmp(vocabulary,words(i)));

if(numel(position_unique)>0)
positions=find(strcmp(vocabulary_stem,words_stem(i)));

if numel(positions)>1
vectors_temp=wordvectors(positions,:);
vectors_temp_unique=wordvectors(position_unique(1),:);
vectors_temp_dist=pdist2(vectors_temp_unique,vectors_temp,'cosine');
temp_dist_gauss=2-(cdf('norm',vectors_temp_dist,0,smooth)*2);
temp_weight=vectors_temp.*temp_dist_gauss';
wordvectors_extracted(i,:)=sum(temp_weight,1);
end

if numel(positions)==1
wordvectors_extracted(i,:)=wordvectors(position_unique(1),:);
end
	
end

end
end

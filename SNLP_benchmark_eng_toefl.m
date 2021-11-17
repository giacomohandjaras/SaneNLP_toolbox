function [accuracy,dof,coverage]=SNLP_benchmark_eng_toefl(corpora,smoothing)

iterations=numel(smoothing);
accuracy=nan(iterations,1);
dof=nan(1,1);
coverage=100;

load 'SNLP_benchmark_eng_toefl.mat';


if (isstruct(corpora)==0)
corpora=load(corpora);
end

questions=numel(probes);
answers=size(alternatives,2);
alternatives_mask=nan(questions,answers);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:questions
for j=1:answers
vectors_mask=SNLP_searchWords(alternatives(i,j), corpora.wordlist);
alternatives_mask(i,j)=sum(vectors_mask);
end
end

[vectors_mask] = SNLP_searchWords(probes, corpora.wordlist);
vectors_mask_alt=sum(alternatives_mask,2);
vectors_mask=vectors_mask.*(vectors_mask_alt==answers);

%%%%eliminiamo gli elementi che non sono presenti nel corpora a cui non possiamo rispondere
probes(find(vectors_mask==0))=[];
probes_stem(find(vectors_mask==0))=[];
alternatives(find(vectors_mask==0),:)=[];
alternatives_stem(find(vectors_mask==0),:)=[];
alternatives_mask(find(vectors_mask==0),:)=[];
correct(find(vectors_mask==0),:)=[];

coverage=sum(vectors_mask)/numel(vectors_mask)*100;

questions=numel(correct);
correct_w2v=nan(questions,1);

for j=1:iterations
smooth=smoothing(j);

for i=1:questions
wordvectors_extracted_o=nan(answers,size(corpora.vectors_matrix,2));
wordvectors_extracted=nan(1,size(corpora.vectors_matrix,2));

if(smooth>0)
wordvectors_extracted = SNLP_getWordVectorsSmoothed(probes(i), corpora.wordlist, corpora.vectors_matrix, probes_stem(i), corpora.wordlist_stem, smooth);
for k=1:answers
wordvectors_extracted_o(k,:) = SNLP_getWordVectorsSmoothed(alternatives(i,k), corpora.wordlist, corpora.vectors_matrix, alternatives_stem(i,k), corpora.wordlist_stem, smooth);
end
else
wordvectors_extracted = SNLP_getWordVectors(probes(i), corpora.wordlist, corpora.vectors_matrix);
for k=1:answers
wordvectors_extracted_o(k,:) = SNLP_getWordVectors(alternatives(i,k), corpora.wordlist, corpora.vectors_matrix);
end
end

distances=pdist2(wordvectors_extracted,wordvectors_extracted_o,'cosine');
[~,indx]=min(distances);
correct_w2v(i)=indx;
end

accuracy(j)=numel(find((correct_w2v-correct)==0))/questions;
end


dof=questions;

end

function [accuracy,dof,coverage]=SNLP_benchmark_eng_toefl(corpus,smoothing)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Test word-embeddings from a english-based corpus with behavioral feature-norming data from TOEFL Synonym Questions (http://lsa.colorado.edu/).
%%%%
%%%%Usage:
%%%%	[accuracy,dof,coverage]=SNLP_benchmark_eng_toefl(corpus,smoothing)
%%%%
%%%%	corpus: a char variable indicating the filename of a .mat containing word2vec embeddings
%%%%	         or directly the struct containing word-embeddings (see SNLP_convertW2VtoMAT)
%%%%	smoothing: a positive float (generally between 0 and 1) or an array of positive floats indicating the level of gaussian smoothings
%%%%	           (sigma of a distro centered on a cosine distance of 0) to be tested (see SNLP_getWordVectorsSmoothed)
%%%%
%%%%	accuracy: accuracy evaluated considering the cosine distance between the stem and the four choices in the word-embeddings. Chance level is 25%.
%%%%	dof: number of tests performed (depending on the number of words included in the corpus)
%%%%	coverage: since the vocabulary of the word-embeddings depends on the size of the corpus,
%%%%	          some words present in behavioral data could not be represented in the word-embeddings.
%%%%	          Coverage measures the overlap in % between the words in behavioral data and the corpus.
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iterations=numel(smoothing);
accuracy=nan(iterations,1);
dof=nan(1,1);
coverage=100;

load 'SNLP_benchmark_eng_toefl.mat';

if (isstruct(corpus)==0)
    corpus=load(corpus);
end

questions=numel(probes);
answers=size(alternatives,2);
alternatives_mask=nan(questions,answers);

for i=1:questions
    for j=1:answers
        vectors_mask=SNLP_searchWords(alternatives(i,j), corpus.wordlist);
        alternatives_mask(i,j)=sum(vectors_mask);
    end
end

[vectors_mask] = SNLP_searchWords(probes, corpus.wordlist);
vectors_mask_alt=sum(alternatives_mask,2);
vectors_mask=vectors_mask.*(vectors_mask_alt==answers);

%%%%remove all the elements which are not included in word-embeddings
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
        wordvectors_extracted_o=nan(answers,size(corpus.vectors_matrix,2));
        wordvectors_extracted=nan(1,size(corpus.vectors_matrix,2));
        
        if(smooth>0)
            wordvectors_extracted = SNLP_getWordVectorsSmoothed(probes(i), corpus.wordlist, corpus.vectors_matrix, probes_stem(i), corpus.wordlist_stem, smooth);
            for k=1:answers
                wordvectors_extracted_o(k,:) = SNLP_getWordVectorsSmoothed(alternatives(i,k), corpus.wordlist, corpus.vectors_matrix, alternatives_stem(i,k), corpus.wordlist_stem, smooth);
            end
        else
            wordvectors_extracted = SNLP_getWordVectors(probes(i), corpus.wordlist, corpus.vectors_matrix);
            for k=1:answers
                wordvectors_extracted_o(k,:) = SNLP_getWordVectors(alternatives(i,k), corpus.wordlist, corpus.vectors_matrix);
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

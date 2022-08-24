function [r,rho,coverage]=SNLP_benchmark_eng_simlex999(corpus,smoothing)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Test word-embeddings from a english-based corpus with behavioral feature-norming data from Hill et al., 2014.
%%%%	Hill, F., Reichart, R., & Korhonen, A. (2015).
%%%%	Simlex-999: Evaluating semantic models with (genuine) similarity estimation.
%%%%	Computational Linguistics, 41(4), 665-695.
%%%%	doi: 10.1162/COLI_a_00237
%%%%
%%%%Usage:
%%%%	[r,rho,coverage]=SNLP_benchmark_eng_simlex999(corpus,smoothing)
%%%%
%%%%	corpus: a char variable indicating the filename of a .mat containing word2vec embeddings
%%%%	         or directly the struct containing word-embeddings (see SNLP_convertW2VtoMAT)
%%%%	smoothing: a positive float (generally between 0 and 1) or an array of positive floats indicating the level of gaussian smoothings
%%%%	           (sigma of a distro centered on a cosine distance of 0) to be tested (see SNLP_getWordVectorsSmoothed)
%%%%
%%%%	r: the Pearson's correlation coefficient between the RDM from word-embeddings of the corpus
%%%%	   (cosine distance) and the RDM (cosine distance) obtained from behavioral data.
%%%%	rho: as above but using Spearman's rho.
%%%%	coverage: since the vocabulary of the word-embeddings depends on the size of the corpus,
%%%%	          some words present in behavioral data could not be represented in the word-embeddings.
%%%%	          Coverage measures the overlap in % between the words in behavioral data and the corpus.
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iterations=numel(smoothing);
r=nan(iterations,1);
rho=nan(iterations,1);
coverage=100;

load 'SNLP_benchmark_eng_simlex999.mat';

if (isstruct(corpus)==0)
    corpus=load(corpus);
end

%%%%Find the words in the dictionary of word-embeddings
[vectors_mask_col1] = SNLP_searchWords(word1, corpus.wordlist);
[vectors_mask_col2] = SNLP_searchWords(word2, corpus.wordlist);
vectors_mask=vectors_mask_col1.*vectors_mask_col2;

coverage=sum(vectors_mask)/numel(vectors_mask)*100;

similarity(find(vectors_mask==0))=[];
word1(find(vectors_mask==0))=[];
word2(find(vectors_mask==0))=[];
word1_stem(find(vectors_mask==0))=[];
word2_stem(find(vectors_mask==0))=[];

distances=nan(iterations,size(similarity,1));


for j=1:iterations
    smooth=smoothing(j);
    
    for i=1:size(similarity,1)
        
        if(smooth>0)
            wordvectors_extracted_col1 = SNLP_getWordVectorsSmoothed(word1(i), corpus.wordlist, corpus.vectors_matrix, word1_stem(i), corpus.wordlist_stem, smooth);
            wordvectors_extracted_col2 = SNLP_getWordVectorsSmoothed(word2(i), corpus.wordlist, corpus.vectors_matrix, word2_stem(i), corpus.wordlist_stem, smooth);
        else
            wordvectors_extracted_col1 = SNLP_getWordVectors(word1(i), corpus.wordlist, corpus.vectors_matrix);
            wordvectors_extracted_col2 = SNLP_getWordVectors(word2(i), corpus.wordlist, corpus.vectors_matrix);
        end
        
        distances(j,i)=1-pdist2(wordvectors_extracted_col1,wordvectors_extracted_col2,'cosine');
        
    end
end


r=corr(similarity,distances');
rho=corr(similarity,distances','type','spearman');
end

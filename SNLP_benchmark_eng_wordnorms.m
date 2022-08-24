function [r,rho,acc,RDM_behav,RDM_corpus,concepts_labels,coverage]=SNLP_benchmark_eng_wordnorms(corpus,smoothing)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Test word-embeddings from a english-based corpus with behavioral feature-norming data from Buchanan et al. semantic word-pair norms (2013).
%%%% 	Buchanan, E. M., Holmes, J. L., Teasley, M. L., & Hutchison, K. A. (2013).
%%%% 	English semantic word-pair norms and a searchable Web portal for experimental stimulus creation.
%%%% 	Behavior research methods, 45(3), 746-757.
%%%%	doi: 10.3758/s13428-012-0284-z
%%%%
%%%%Usage:
%%%%	[r,rho,acc,RDM_behav,RDM_corpus,concepts_labels,coverage]=SNLP_benchmark_eng_wordnorms(corpus,smoothing)
%%%%
%%%%	corpus: a char variable indicating the filename of a .mat containing word2vec embeddings
%%%%	         or directly the struct containing word-embeddings (see SNLP_convertW2VtoMAT)
%%%%	smoothing: a positive float (generally between 0 and 1) or an array of positive floats indicating the level of gaussian smoothings
%%%%	           (sigma of a distro centered on a cosine distance of 0) to be tested (see SNLP_getWordVectorsSmoothed)
%%%%
%%%%	r: the Pearson's correlation coefficient between the RDM from word-embeddings of the corpus
%%%%	   (cosine distance) and the RDM (cosine distance) obtained from behavioral data.
%%%%	rho: as above but using Spearman's rho.
%%%%	acc: accuracy evaluated with a similarity encoding analysis (see SNLP_similarity_encoding).
%%%%	RDM_behav: RDM (cosine distance) obtained from behavioral data
%%%%	RDM_corpus: RDM (cosine distance) obtained from word-embeddings
%%%%	concepts_labels: the labels of the stimuli used to generate RDM_behav and RDM_corpus
%%%%	coverage: since the vocabulary of the word-embeddings depends on the size of the corpus,
%%%%	          some words present in behavioral data could not be represented in the word-embeddings.
%%%%	          Coverage measures the overlap in % between the words in behavioral data and the corpus.
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

concepts_labels={};
iterations=numel(smoothing);
r=nan(iterations,1);
rho=nan(iterations,1);
acc=nan(iterations,1);
RDM_behav=[];
RDM_corpus=[];
coverage=[];
accuracy_tot=[];

load 'SNLP_benchmark_eng_wordnorms.mat';

%%%%%Open the corpus
if (isstruct(corpus)==0)
    corpus=load(corpus);
end

[vectors_mask] = SNLP_searchWords(words_eng, corpus.wordlist);

all_words(find(vectors_mask==0))=[];
words_eng_stem(find(vectors_mask==0))=[];
words_eng(find(vectors_mask==0))=[];
num_of_stim=numel(words_eng);

concepts_labels=words_eng;
coverage=sum(vectors_mask)/numel(vectors_mask)*100;


%%%%%Tokenize data and normalize it
documents = tokenizedDocument(all_words);
bag = bagOfWords(documents);

normalized_occurrences=full(tfidf(bag,'TFWeight','log','IDFWeight','normal'));

RDM_behav=pdist(normalized_occurrences,'cosine');
RDM_corpus=nan(iterations,numel(RDM_behav));

for j=1:iterations
    smooth=smoothing(j);
    
    if(smooth>0)
        wordvectors_extracted = SNLP_getWordVectorsSmoothed(words_eng, corpus.wordlist, corpus.vectors_matrix, words_eng_stem, corpus.wordlist_stem, smooth);
    else
        wordvectors_extracted = SNLP_getWordVectors(words_eng, corpus.wordlist, corpus.vectors_matrix);
    end
    RDM_cor=pdist(wordvectors_extracted,'cosine');
    
    r(j)=corr(RDM_behav',RDM_cor');
    rho(j)=corr(RDM_behav',RDM_cor','type','spearman');
    [~, accuracy_tot] = SNLP_similarity_encoding(squareform(RDM_cor), squareform(RDM_behav), 'correlation');
    acc(j)=accuracy_tot;
    RDM_corpus(j,:)=RDM_cor;
end

end

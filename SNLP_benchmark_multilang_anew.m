function [r,rho,acc,RDM_lang1,RDM_lang2,concepts_labels,coverage]=SNLP_benchmark_multilang_anew(corpus_lang1,lang1,corpus_lang2,lang2,smoothing)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Compare two word-embeddings from different languages related to a set of words in the ANEW dataset.
%%%%For English:
%%%%	Bradley, Margaret M., and Peter J. Lang. Affective norms for English words (ANEW): Instruction manual and affective ratings. 
%%%%	Vol. 30. No. 1. Technical report C-1, the center for research in psychophysiology, University of Florida, (1999).
%%%%	doi: 10.3758/s13428-017-1009-0
%%%%
%%%%For Italian:
%%%%	Montefinese, M., Ambrosini, E., Fairfield, B., & Mammarella, N. (2014). The adaptation of the affective norms for English words (ANEW) for Italian.
%%%%	Behavior research methods, 46(3), 887-903.
%%%%	doi: 10.3758/s13428-013-0405-3
%%%%
%%%%For French:
%%%%	a) Monnier, C., & Syssau, A. (2014). Affective norms for French words (FAN). 
%%%%	   Behavior research methods, 46(4), 1128-1137.
%%%%	   doi: 10.3758/s13428-013-0431-1
%%%%	b) Gilet, A.-L., Grühn, D., Studer, J., & Labouvie-Vief, G. (2012). Valence, arousal, and imagery ratings for 835 French attributes by young, middle-aged, and older adults: The French Emotional Evaluation List (FEEL). 
%%%%	   European Review of Applied Psychology / Revue Européenne de Psychologie Appliquée, 62(3), 173–181. 
%%%%	   doi: 10.1016/j.erap.2012.03.003
%%%%	c) Bertels, J., Kolonsky, R. and Morais, J., 2009. Norms of Emotional Valence, Arousal, Threat Value and Shock Value for 80 Spoken French Words: Comparison Between Neutral and Emotional Tones of Voice. 
%%%%	   Psychologica Belgica, 49(1), pp.19–40.
%%%%	   doi: 10.5334/pb-49-1-19
%%%%
%%%%For Spanish:
%%%%	Redondo, J., Fraga, I., Padrón, I., & Comesaña, M. (2007). The Spanish adaptation of ANEW (affective norms for English words).
%%%%	Behavior research methods, 39(3), 600-605.
%%%%	doi: 10.3758/bf03193031

%%%%Usage:
%%%%	[r,rho,acc,RDM_lang1,RDM_lang2,concepts_labels,coverage]=SNLP_benchmark_multilang_anew(corpus_lang1,lang1,corpus_lang2,lang2,smoothing)
%%%%
%%%%	corpus_lang1: a char variable indicating the filename of a .mat containing word2vec embeddings
%%%%	              or directly the struct containing word-embeddings (see SNLP_convertW2VtoMAT) for the first language
%%%%	lang1: the language of the first set of word-embeddings. It could be 'ita', 'eng' or 'fra'.
%%%%	corpus_lang2: a char variable indicating the filename of a .mat containing word2vec embeddings
%%%%	              or directly the struct containing word-embeddings (see SNLP_convertW2VtoMAT) for the second language
%%%%	lang2: the language of the second set of word-embeddings. It could be 'ita', 'eng' or 'fra'.
%%%%	smoothing: a positive float (generally between 0 and 1) or an array of positive floats indicating the level of gaussian smoothings
%%%%	           (sigma of a distro centered on a cosine distance of 0) to be tested (see SNLP_getWordVectorsSmoothed)
%%%%
%%%%	r: the Pearson's correlation coefficient between the RDM from word-embeddings of the first corpus
%%%%	   (cosine distance) and the RDM (cosine distance) obtained from the second one.
%%%%	rho: as above but using Spearman's rho.
%%%%	acc: accuracy evaluated with a similarity encoding analysis (see SNLP_similarity_encoding).
%%%%	RDM_lang1: RDM (cosine distance) obtained from the first set of word embeddings
%%%%	RDM_lang2: RDM (cosine distance) obtained from the second set of word embeddings
%%%%	concepts_labels: the labels of the stimuli used to generate create and compare the two corpora
%%%%	coverage: since the vocabulary of the word-embeddings depends on the size of the corpus,
%%%%	          some words present in ANEW set a could not be represented in the word-embeddings.
%%%%	          Coverage measures the overlap in % between the words in ANEW data and the two corpora.
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

concepts_labels={};
iterations=numel(smoothing);
r=nan(iterations,1);
rho=nan(iterations,1);
acc=nan(iterations,1);
RDM_lang1=[];
RDM_lang2=[];
coverage=[];

load 'SNLP_benchmark_multilang_anew.mat';

%%%%%Open the corpora
if (isstruct(corpus_lang1)==0)
    corpus_lang1=load(corpus_lang1);
end
if (isstruct(corpus_lang2)==0)
    corpus_lang2=load(corpus_lang2);
end


lang1=lower(lang1);
lang2=lower(lang2);

if(strcmp(lang1,'ita')); words_lang1=words_ita; words_lang1_stem=words_ita_stem; end
if(strcmp(lang1,'eng')); words_lang1=words_eng; words_lang1_stem=words_eng_stem; end
if(strcmp(lang1,'fra')); words_lang1=words_fra; words_lang1_stem=words_fra_stem; end

if(strcmp(lang2,'ita')); words_lang2=words_ita; words_lang2_stem=words_ita_stem; end
if(strcmp(lang2,'eng')); words_lang2=words_eng; words_lang2_stem=words_eng_stem; end
if(strcmp(lang2,'fra')); words_lang2=words_fra; words_lang2_stem=words_fra_stem; end


[vectors_mask_lang1] = SNLP_searchWords(words_lang1, corpus_lang1.wordlist);
[vectors_mask_lang2] = SNLP_searchWords(words_lang2, corpus_lang2.wordlist);

vectors_mask=vectors_mask_lang1.*vectors_mask_lang2;

words_lang1(find(vectors_mask==0))=[];
words_lang1_stem(find(vectors_mask==0))=[];
words_lang2(find(vectors_mask==0))=[];
words_lang2_stem(find(vectors_mask==0))=[];
concepts_labels=words_eng;
concepts_labels(find(vectors_mask==0))=[];

num_of_stim=numel(words_lang1);
coverage=sum(vectors_mask)/numel(vectors_mask)*100;

RDM_corpus=nan(iterations,num_of_stim*(num_of_stim-1)/2);

for j=1:iterations
    smooth=smoothing(j);
    
    if(smooth>0)
        wordvectors_extracted_lang1 = SNLP_getWordVectorsSmoothed(words_lang1, corpus_lang1.wordlist, corpus_lang1.vectors_matrix, words_lang1_stem, corpus_lang1.wordlist_stem, smooth);
        wordvectors_extracted_lang2 = SNLP_getWordVectorsSmoothed(words_lang2, corpus_lang2.wordlist, corpus_lang2.vectors_matrix, words_lang2_stem, corpus_lang2.wordlist_stem, smooth);
    else
        wordvectors_extracted_lang1 = SNLP_getWordVectors(words_lang1, corpus_lang1.wordlist, corpus_lang1.vectors_matrix);
        wordvectors_extracted_lang2 = SNLP_getWordVectors(words_lang2, corpus_lang2.wordlist, corpus_lang2.vectors_matrix);
    end
    RDM_temp_lang1=pdist(wordvectors_extracted_lang1,'cosine');
    RDM_temp_lang2=pdist(wordvectors_extracted_lang2,'cosine');
    
    r(j)=corr(RDM_temp_lang1',RDM_temp_lang2');
    rho(j)=corr(RDM_temp_lang1',RDM_temp_lang2','type','spearman');
    [~, accuracy_tot] = SNLP_similarity_encoding(squareform(RDM_temp_lang1), squareform(RDM_temp_lang2), 'correlation');
    acc(j)=accuracy_tot;
    RDM_lang1(j,:)=RDM_temp_lang1;
    RDM_lang2(j,:)=RDM_temp_lang2;
end

end


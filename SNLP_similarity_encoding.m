function [accuracy_square, accuracy_tot]=SNLP_similarity_encoding(A,B,distance)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Given two similarity matrices and a distance, the function perform a similarity encoding analysis.
%%%% 	Please refers to:
%%%% 	 	Anderson, Andrew James, Benjamin D. Zinszer, and Rajeev DS Raizada. "Representational similarity encoding for fMRI: Pattern-based synthesis to predict brain activity using stimulus-model-similarities." NeuroImage 128 (2016): 44-53.
%%%% 	 	Handjaras, G., Leo, A., Cecchetti, L., Papale, P., Lenci, A., Marotta, G., ... & Ricciardi, E. (2017). Modality-independent encoding of individual concepts in the left parietal cortex. Neuropsychologia, 105, 39-49.
%%%%
%%%%Usage:
%%%%	[accuracy_square, accuracy_tot]=SNLP_similarity_encoding(A,B,distance)
%%%%
%%%%	A and B: symmetric, square matrices with the same dimensionality to be compared
%%%%	distance: the distance to compare the two matrices. It could be any distance supported by pdist
%%%%
%%%%	accuracy_square: a matrix of the same dimensionality of A and B. It contains 0, 1 and 2, according to the raw score
%%%%	accuracy_tot: the global accuracy obtained from accuracy_square
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elements=size(A,1);
accuracy_square=zeros(elements,elements);
accuracy_tot=nan(1,1);


pairings=nan(elements*(elements-1)/2,2);
index=1;
for i=1:elements
    for j=(i+1):elements
        pairings(index,:)=[i,j];
        index=index+1;
    end
end
index=index-1;

score_tot=0;
for i=1:index
    pair=pairings(i,:);
    A_sel=A(pair,:);
    B_sel=B(pair,:);
    A_sel(:,pair)=[];
    B_sel(:,pair)=[];
    
    distances_temp=pdist2(A_sel,B_sel,distance);
    
    [~,min_indx]=min(distances_temp);
    
    score=0;
    if(min_indx(1)==1); score=score+1; end
    if(min_indx(2)==2); score=score+1; end
    accuracy_square(pairings(i,1),pairings(i,2))=score;
    accuracy_square(pairings(i,2),pairings(i,1))=score;
    
    score_tot=score_tot+score;
end

accuracy_tot=score_tot/(index*2);

end

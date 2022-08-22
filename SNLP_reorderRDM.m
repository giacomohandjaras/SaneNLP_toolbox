function RDM_sorted=SNLP_reorderRDM(RDM, sort_order)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Given a square Representational Dissimilarity Matrix (RDM), re-order rows and columns
%%%%
%%%%Usage:
%%%%	RDM_sorted=SNLP_reorderRDM(RDM, sort_order)
%%%%
%%%%	RDM: symmetric, square matrix (N x N)
%%%%	sort_order: a numerical matrix (N x 1) containing the new order of the elements of RDM
%%%%
%%%%	RDM_sorted: RDM re-sorted
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dim=size(RDM,1);
RDM_sorted=nan(dim,dim);


for i=1:dim
    for j=(i+1):dim
        RDM_sorted(i,j)=RDM(sort_order(i),sort_order(j));
        RDM_sorted(j,i)=RDM_sorted(i,j);
    end
end

for i=1:dim
    RDM_sorted(i,i)=RDM(sort_order(i),sort_order(i));
end

end

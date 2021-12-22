function SNLP_saveWords(filename,data);

lines=size(data,1);
columns=size(data,2);

fid = fopen(filename,'wt');

for l=1:lines
 str=string(data{l,1});
 
 for c=2:columns
 str=strcat(str,',',string(data{l,c}));
 end

 if strlength(str)>0
 fprintf(fid, '%s\n',str);
 end
 
end
 fclose(fid);
	
end

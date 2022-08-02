function word_out_final = SNLP_stemming_fra(word_in)
%%%vers 0.1

debug=0;
french_vowels='[aeiouyâàëéêèïîôûù]';
french_vowels_extra='[aeiouyâàëéêèïîôûùH]';
french_consonants='[bcçdfghjklmnpqrstvxwzHIUY]';

french_suffix_step1a={'ance'   'iqUe'   'isme'   'able'   'iste'   'eux'   'ances'   'iqUes'   'ismes'   'ables'   'istes'};
french_suffix_step1b={'atrice'   'ateur'   'ation'   'atrices'   'ateurs'   'ations'};
french_suffix_step1c={'logie'   'logies'};
french_suffix_step1d={'usion'   'ution'   'usions'   'utions'};
french_suffix_step1e={'ence'   'ences'};
french_suffix_step1f={'ement'   'ements'};
french_suffix_step1g={'ité'   'ités'};
french_suffix_step1h={'if'   'ive'   'ifs'   'ives'};
french_suffix_step1m={'euse'   'euses'};
french_suffix_step1n={'issement'   'issements'};
french_suffix_step1q={'ment'   'ments'};

french_suffix_step2a={ 'îmes'   'ît'   'îtes'   'i'   'ie'   'ies'   'ir'   'ira'   'irai'   'iraIent'   'irais'   'irait'   'iras'   'irent'   'irez'   'iriez'   'irions'   'irons'   'iront'   'is'   'issaIent'   'issais'   'issait'   'issant'   'issante'   'issantes'   'issants'   'isse'   'issent'   'isses'   'issez'   'issiez'   'issions'   'issons'   'it' };
french_suffix_step2b2={ 'é'   'ée'   'ées'   'és'   'èrent'   'er'   'era'   'erai'   'eraIent'   'erais'   'erait'   'eras'   'erez'   'eriez'   'erions'   'erons'   'eront'   'ez'   'iez' };
french_suffix_step2b3={ 'âmes'   'ât'   'âtes'   'a'   'ai'   'aIent'   'ais'   'ait'   'ant'   'ante'   'antes'   'ants'   'as'   'asse'   'assent'   'asses'   'assiez'   'assions' };

french_suffix_step4a={ 'as' 'is' 'os' 'us' 'ès' 'ss' };
french_suffix_step4b={ 'ier'   'ière'   'Ier'   'Ière' };


%lowercase conversion
word_out=lower(word_in);

%0) Return short words.
if length(word_out)<=1
word_out_final=word_out;
return 
end

%SNOWBALL FRA
%%%%%PRELUDE
%first possible output
word_out_final=word_out;

%1)put u or i into upper case when it is both preceded and followed by a vowel; put y into upper case when it is either preceded or followed by a vowel; and put u into upper case when it follows q
word_out = regexprep(word_out,'qu','qU');
expression=strcat('([',french_vowels,'])y([',french_vowels,'])');
word_out = regexprep(word_out,expression,'$1Y$2');
expression=strcat('y([',french_vowels,'])');
word_out = regexprep(word_out,expression,'Y$1');
expression=strcat('([',french_vowels,'])y');
word_out = regexprep(word_out,expression,'$1Y');
expression=strcat('([',french_vowels,'])u([',french_vowels,'])');
word_out = regexprep(word_out,expression,'$1U$2');
expression=strcat('([',french_vowels,'])i([',french_vowels,'])');
word_out = regexprep(word_out,expression,'$1I$2');


%2) replace diaeresis
word_out = regexprep(word_out,'ë','He');
word_out = regexprep(word_out,'ï','Hi');


%%%%%MARK REGIONS
%3)defining R1, R2 (see the note on R1 and R2) and RV 
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
if (debug==1);disp(sprintf('W: %s, R1: %s, R2: %s, RV: %s',word_out,R1,R2,RV));end



%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%And now, start the stemming for real!!!
%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%STEP1
%%%%%%%%%%%%%%%%%%%%%%%%
modifications_step1=0;
goto_step2a=0;

%%%%step1n %%%Va anticipato perchè overlappa con step1f?
if(modifications_step1==0)
[R1_position, word_position ,exception]=SNLP_get_longest_exception(R1,word_out,french_suffix_step1n);
if length(exception)>0
if (debug==1);disp(sprintf('STEP 1N'));end
modifications_step1=1;
word_out_mask_consonants = regexp(word_out,french_consonants);
if sum(word_out_mask_consonants==(word_position(1)-1))==1
word_out=regexprep(word_out,strcat(exception,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end
end

%%%%step1a
if(modifications_step1==0)
[~, ~, exception]=SNLP_get_longest_exception(R2,word_out,french_suffix_step1a);
if length(exception)>0
if (debug==1);disp(sprintf('STEP 1A'));end
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end

%%%%step1b
if(modifications_step1==0)
[~, ~,exception]=SNLP_get_longest_exception(R2,word_out,french_suffix_step1b);
if length(exception)>0
if (debug==1);disp(sprintf('STEP 1B'));end
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');

[~, ~,exception]=SNLP_get_longest_exception(R2,word_out,{'ic'});
if length(exception)>0
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
else
[~, ~,exception]=SNLP_get_longest_exception(R1,word_out,{'ic'});
if length(exception)>0
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'iqU');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end
end
end

%%%%step1c
if(modifications_step1==0)
[~, ~,exception]=SNLP_get_longest_exception(R2,word_out,french_suffix_step1c);
if length(exception)>0
if (debug==1);disp(sprintf('STEP 1C'));end
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'log');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end

%%%%step1d
if(modifications_step1==0)
[~, ~,exception]=SNLP_get_longest_exception(R2,word_out,french_suffix_step1d);
if length(exception)>0
if (debug==1);disp(sprintf('STEP 1D'));end
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'u');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end

%%%%step1e
if(modifications_step1==0)
[~, ~,exception]=SNLP_get_longest_exception(R2,word_out,french_suffix_step1e);
if length(exception)>0
if (debug==1);disp(sprintf('STEP 1E'));end
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'ent');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end

%%%%step1f
if(modifications_step1==0)
[~, ~,exception]=SNLP_get_longest_exception(RV,word_out,french_suffix_step1f);
if length(exception)>0
if (debug==1);disp(sprintf('STEP 1F'));end
modifications_step1=1;
[~, ~,exception2]=SNLP_get_longest_exception(R2,word_out,strcat('ativ',{exception}));
if length(exception2)>0
word_out=regexprep(word_out,strcat(exception2,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
[~, ~,exception2]=SNLP_get_longest_exception(R2,word_out,strcat('iv',{exception}));
if length(exception2)>0
word_out=regexprep(word_out,strcat(exception2,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
[~, ~,exception2]=SNLP_get_longest_exception(R2,word_out,strcat('eus',{exception}));
if length(exception2)>0
word_out=regexprep(word_out,strcat(exception2,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
[~, ~,exception2]=SNLP_get_longest_exception(R1,word_out,strcat('eus',{exception}));
if length(exception2)>0
word_out=regexprep(word_out,strcat(exception,'$'),'');
word_out=regexprep(word_out,strcat('eus','$'),'eux');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
[~, ~,exception2]=SNLP_get_longest_exception(R2,word_out,strcat('abl',{exception}));
if length(exception2)>0
word_out=regexprep(word_out,strcat(exception2,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
[~, ~,exception2]=SNLP_get_longest_exception(R2,word_out,strcat('iqU',{exception}));
if length(exception2)>0
word_out=regexprep(word_out,strcat(exception2,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
[~, ~,exception2]=SNLP_get_longest_exception(RV,word_out,strcat('ièr',{exception}));
if length(exception2)>0
word_out=regexprep(word_out,strcat(exception2,'$'),'i');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
[~, ~,exception2]=SNLP_get_longest_exception(RV,word_out,strcat('Ièr',{exception}));
if length(exception2)>0
word_out=regexprep(word_out,strcat(exception2,'$'),'i');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
word_out=regexprep(word_out,strcat(exception,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end

%%%%step1g
if(modifications_step1==0)
[~, ~,exception]=SNLP_get_longest_exception(R2,word_out,french_suffix_step1g);
if length(exception)>0
if (debug==1);disp(sprintf('STEP 1G'));end
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');

[~, ~,exception]=SNLP_get_longest_exception(R2,word_out,{'abil'});
if length(exception)>0
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
else
[~, ~,exception]=SNLP_get_longest_exception(R1,word_out,{'abil'});
if length(exception)>0
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'abl');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end

[~, ~,exception]=SNLP_get_longest_exception(R2,word_out,{'ic'});
if length(exception)>0
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
else
[~, ~,exception]=SNLP_get_longest_exception(R1,word_out,{'ic'});
if length(exception)>0
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'iqU');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end

[~, ~,exception]=SNLP_get_longest_exception(R2,word_out,{'iv'});
if length(exception)>0
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end
end

%%%%step1h
if(modifications_step1==0)
[~, ~,exception]=SNLP_get_longest_exception(R2,word_out,french_suffix_step1h);
if length(exception)>0
if (debug==1);disp(sprintf('STEP 1H'));end
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');

[~, ~,exception]=SNLP_get_longest_exception(R2,word_out,{'at'});
if length(exception)>0
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');

[~, ~,exception]=SNLP_get_longest_exception(R2,word_out,{'ic'});
if length(exception)>0
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
else
[~, ~,exception]=SNLP_get_longest_exception(R1,word_out,{'ic'});
if length(exception)>0
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'iqU');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end

end
end
end

%%%%step1i
if(modifications_step1==0)
[~, ~,exception]=SNLP_get_longest_exception(word_out,word_out,{'eaux'});
if length(exception)>0
if (debug==1);disp(sprintf('STEP 1i'));end
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'eau');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end

%%%%step1l
if(modifications_step1==0)
[~, ~,exception]=SNLP_get_longest_exception(R1,word_out,{'aux'});
if length(exception)>0
if (debug==1);disp(sprintf('STEP 1L'));end
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'al');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end

%%%%step1m
if(modifications_step1==0)
[~, ~,exception]=SNLP_get_longest_exception(R2,word_out,french_suffix_step1m);
if length(exception)>0
if (debug==1);disp(sprintf('STEP 1M'));end
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
else
[~, ~,exception]=SNLP_get_longest_exception(R1,word_out,french_suffix_step1m);
if length(exception)>0
if (debug==1);disp(sprintf('STEP 1M'));end
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'eux');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end
end


%%%%step1o
if(modifications_step1==0)
[~, ~,exception]=SNLP_get_longest_exception(RV,word_out,{'amment'});
if length(exception)>0
if (debug==1);disp(sprintf('STEP 1O'));end
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'ant');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
goto_step2a=1;
end
end

%%%%step1p
if(modifications_step1==0)
[~, ~,exception]=SNLP_get_longest_exception(RV,word_out,{'emment'});
if length(exception)>0
if (debug==1);disp(sprintf('STEP 1P'));end
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'ent');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
goto_step2a=1;
end
end

%%%%step1q
if(modifications_step1==0)
[RV_position, word_position ,exception]=SNLP_get_longest_exception(RV,word_out,french_suffix_step1q);
if length(exception)>0
if (debug==1);disp(sprintf('STEP 1Q'));end
RV_mask_vowels = regexp(RV,french_vowels);
if(RV_position(1)>=2)
if sum(RV_mask_vowels==(RV_position(1)-1))==1
modifications_step1=1;
word_out=regexprep(word_out,strcat(exception,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
goto_step2a=1;
end
end
end
end


%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%STEP2
%%%%%%%%%%%%%%%%%%%%%%%%
modifications_step2a=0;
modifications_step2b=0;
goto_step2b=0;

if (modifications_step1==0 | goto_step2a==1)
goto_step2b=1;
if (debug==1);disp(sprintf('STEP 2A'));end
[RV_position, word_position ,exception]=SNLP_get_longest_exception(RV,word_out,french_suffix_step2a);
if length(exception)>0
RV_mask_vowels = regexp(RV,french_vowels_extra);
if(RV_position(1)>=2)
if sum(RV_mask_vowels==(RV_position(1)-1))==0
goto_step2b=0;
modifications_step2a=1;
word_out=regexprep(word_out,strcat(exception,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end
end
end


if (modifications_step2a==0 & goto_step2b==1)
%%%%step2b2
if(modifications_step2b==0)
[~, ~,exception]=SNLP_get_longest_exception(RV,word_out,french_suffix_step2b2);
if length(exception)>0
if (debug==1);disp(sprintf('STEP 2B2'));end
modifications_step2b=1;
word_out=regexprep(word_out,strcat(exception,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end

%%%%step2b1
[~, ~,exception]=SNLP_get_longest_exception(R2,word_out,{'ions'});
if length(exception)>0
if (debug==1);disp(sprintf('STEP 2B1'));end
modifications_step2b=1;
word_out=regexprep(word_out,strcat(exception,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end

%%%%step2b3
if(modifications_step2b==0)
[~, ~,exception]=SNLP_get_longest_exception(RV,word_out,french_suffix_step2b3);
if length(exception)>0
if (debug==1);disp(sprintf('STEP 2B3'));end
modifications_step2b=1;
word_out=regexprep(word_out,strcat(exception,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
[~, ~,exception]=SNLP_get_longest_exception(RV,word_out,{'e'});
if length(exception)>0
word_out=regexprep(word_out,strcat(exception,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end
end
end


%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%STEP3
%%%%%%%%%%%%%%%%%%%%%%%%
modifications_step3=0;

if (modifications_step1==1 | modifications_step2a==1 | modifications_step2b==1)
if (debug==1);disp(sprintf('STEP 3'));end
[~, ~,exception]=SNLP_get_longest_exception(word_out,word_out,{'Y'});
if length(exception)>0
word_out=regexprep(word_out,strcat(exception,'$'),'i');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
modifications_step3=1;
end
[~, ~,exception]=SNLP_get_longest_exception(word_out,word_out,{'ç'});
if length(exception)>0
word_out=regexprep(word_out,strcat(exception,'$'),'c');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
modifications_step3=1;
end
end

%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%STEP4
%%%%%%%%%%%%%%%%%%%%%%%%
if (modifications_step1==0 & modifications_step2a==0 & modifications_step2b==0)
if (debug==1);disp(sprintf('STEP 4'));end
[~, ~,exception]=SNLP_get_longest_exception(word_out,word_out,{'s'});
if length(exception)>0 
remove_end_s=1;
[~, ~,exception]=SNLP_get_longest_exception(word_out,word_out,french_suffix_step4a);
if length(exception)>0 
remove_end_s=0;
end
[~, ~,exception]=SNLP_get_longest_exception(word_out,word_out,{'His'});
if length(exception)>0 
remove_end_s=1;
end
if(remove_end_s==1)
word_out=regexprep(word_out,'s$','');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end


[~, ~,exception]=SNLP_get_longest_exception(R2,word_out,{'ion'});
if length(exception)>0
[~, ~,exception]=SNLP_get_longest_exception(RV,word_out,{'sion'});
if length(exception)>0
word_out=regexprep(word_out,'ion$','');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
else
[~, ~,exception]=SNLP_get_longest_exception(RV,word_out,{'tion'});
if length(exception)>0
word_out=regexprep(word_out,'ion$','');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end
end

if(length(RV)>=3)
[~, ~,exception]=SNLP_get_longest_exception(RV,word_out,french_suffix_step4b);
if length(exception)>0
word_out=regexprep(word_out,strcat(exception,'$'),'i');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end

if(length(RV)>=1)
[~, ~,exception]=SNLP_get_longest_exception(RV,word_out,{'e'});
if length(exception)>0
word_out=regexprep(word_out,strcat(exception,'$'),'');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end
end

end


%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%Final steps
%%%%%%%%%%%%%%%%%%%%%%%%

[~, ~,exception]=SNLP_get_longest_exception(word_out,word_out,{'enn'});
if length(exception)>0
if (debug==1);disp(sprintf('FINAL STEPS'));end
word_out=regexprep(word_out,strcat(exception,'$'),'en');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end

[~, ~,exception]=SNLP_get_longest_exception(word_out,word_out,{'onn'});
if length(exception)>0
if (debug==1);disp(sprintf('FINAL STEPS'));end
word_out=regexprep(word_out,strcat(exception,'$'),'on');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end

[~, ~,exception]=SNLP_get_longest_exception(word_out,word_out,{'ett'});
if length(exception)>0
if (debug==1);disp(sprintf('FINAL STEPS'));end
word_out=regexprep(word_out,strcat(exception,'$'),'et');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end

[~, ~,exception]=SNLP_get_longest_exception(word_out,word_out,{'ell'});
if length(exception)>0
if (debug==1);disp(sprintf('FINAL STEPS'));end
word_out=regexprep(word_out,strcat(exception,'$'),'el');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end

[~, ~,exception]=SNLP_get_longest_exception(word_out,word_out,{'eill'});
if length(exception)>0
if (debug==1);disp(sprintf('FINAL STEPS'));end
word_out=regexprep(word_out,strcat(exception,'$'),'eil');
[R1,R2,RV]=SNLP_get_R1R2(word_out, 'fra');
end


expression=strcat('é([',french_consonants,']+$)');
word_out = regexprep(word_out,expression,'e$1');

expression=strcat('è([',french_consonants,']+$)');
word_out = regexprep(word_out,expression,'e$1');

word_out = regexprep(word_out,'I','i');
word_out = regexprep(word_out,'U','u');
word_out = regexprep(word_out,'Y','y');

word_out = regexprep(word_out,'He','ë');
word_out = regexprep(word_out,'Hi','ï');
word_out = regexprep(word_out,'H','');


word_out_final=word_out;
end

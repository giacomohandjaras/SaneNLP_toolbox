function word_out = SNLP_stemming_fra(word_in)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Stem an French word
%%%% 	Snowball version of the French stemmer
%%%% 	see: https://snowballstem.org/algorithms/french/stemmer.html
%%%%
%%%%Usage:
%%%%	[word_out] = SNLP_stemming_fra(word_in)
%%%%
%%%%	word_in: a word in French
%%%%
%%%%	word_out: the stemmed form
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
word_out_temp=lower(word_in);

%0) Return short words.
if length(word_out_temp)<=1
    word_out=word_out_temp;
    return
end

%SNOWBALL FRA
%%%%%PRELUDE
%first possible output
word_out=word_out_temp;

%1)put u or i into upper case when it is both preceded and followed by a vowel; put y into upper case when it is either preceded or followed by a vowel; and put u into upper case when it follows q
word_out_temp = regexprep(word_out_temp,'qu','qU');
expression=strcat('([',french_vowels,'])y([',french_vowels,'])');
word_out_temp = regexprep(word_out_temp,expression,'$1Y$2');
expression=strcat('y([',french_vowels,'])');
word_out_temp = regexprep(word_out_temp,expression,'Y$1');
expression=strcat('([',french_vowels,'])y');
word_out_temp = regexprep(word_out_temp,expression,'$1Y');
expression=strcat('([',french_vowels,'])u([',french_vowels,'])');
word_out_temp = regexprep(word_out_temp,expression,'$1U$2');
expression=strcat('([',french_vowels,'])i([',french_vowels,'])');
word_out_temp = regexprep(word_out_temp,expression,'$1I$2');


%2) replace diaeresis
word_out_temp = regexprep(word_out_temp,'ë','He');
word_out_temp = regexprep(word_out_temp,'ï','Hi');


%%%%%MARK REGIONS
%3)defining R1, R2 (see the note on R1 and R2) and RV
[R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
if (debug==1);disp(sprintf('W: %s, R1: %s, R2: %s, RV: %s',word_out_temp,R1,R2,RV));end



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
    [R1_position, word_position ,exception]=SNLP_getLongestException(R1,word_out_temp,french_suffix_step1n);
    if length(exception)>0
        if (debug==1);disp(sprintf('STEP 1N'));end
        modifications_step1=1;
        word_out_mask_consonants = regexp(word_out_temp,french_consonants);
        if sum(word_out_mask_consonants==(word_position(1)-1))==1
            word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        end
    end
end

%%%%step1a
if(modifications_step1==0)
    [~, ~, exception]=SNLP_getLongestException(R2,word_out_temp,french_suffix_step1a);
    if length(exception)>0
        if (debug==1);disp(sprintf('STEP 1A'));end
        modifications_step1=1;
        word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
        [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
    end
end

%%%%step1b
if(modifications_step1==0)
    [~, ~,exception]=SNLP_getLongestException(R2,word_out_temp,french_suffix_step1b);
    if length(exception)>0
        if (debug==1);disp(sprintf('STEP 1B'));end
        modifications_step1=1;
        word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
        [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        
        [~, ~,exception]=SNLP_getLongestException(R2,word_out_temp,{'ic'});
        if length(exception)>0
            modifications_step1=1;
            word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        else
            [~, ~,exception]=SNLP_getLongestException(R1,word_out_temp,{'ic'});
            if length(exception)>0
                modifications_step1=1;
                word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'iqU');
                [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
            end
        end
    end
end

%%%%step1c
if(modifications_step1==0)
    [~, ~,exception]=SNLP_getLongestException(R2,word_out_temp,french_suffix_step1c);
    if length(exception)>0
        if (debug==1);disp(sprintf('STEP 1C'));end
        modifications_step1=1;
        word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'log');
        [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
    end
end

%%%%step1d
if(modifications_step1==0)
    [~, ~,exception]=SNLP_getLongestException(R2,word_out_temp,french_suffix_step1d);
    if length(exception)>0
        if (debug==1);disp(sprintf('STEP 1D'));end
        modifications_step1=1;
        word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'u');
        [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
    end
end

%%%%step1e
if(modifications_step1==0)
    [~, ~,exception]=SNLP_getLongestException(R2,word_out_temp,french_suffix_step1e);
    if length(exception)>0
        if (debug==1);disp(sprintf('STEP 1E'));end
        modifications_step1=1;
        word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'ent');
        [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
    end
end

%%%%step1f
if(modifications_step1==0)
    [~, ~,exception]=SNLP_getLongestException(RV,word_out_temp,french_suffix_step1f);
    if length(exception)>0
        if (debug==1);disp(sprintf('STEP 1F'));end
        modifications_step1=1;
        [~, ~,exception2]=SNLP_getLongestException(R2,word_out_temp,strcat('ativ',{exception}));
        if length(exception2)>0
            word_out_temp=regexprep(word_out_temp,strcat(exception2,'$'),'');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        end
        [~, ~,exception2]=SNLP_getLongestException(R2,word_out_temp,strcat('iv',{exception}));
        if length(exception2)>0
            word_out_temp=regexprep(word_out_temp,strcat(exception2,'$'),'');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        end
        [~, ~,exception2]=SNLP_getLongestException(R2,word_out_temp,strcat('eus',{exception}));
        if length(exception2)>0
            word_out_temp=regexprep(word_out_temp,strcat(exception2,'$'),'');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        end
        [~, ~,exception2]=SNLP_getLongestException(R1,word_out_temp,strcat('eus',{exception}));
        if length(exception2)>0
            word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
            word_out_temp=regexprep(word_out_temp,strcat('eus','$'),'eux');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        end
        [~, ~,exception2]=SNLP_getLongestException(R2,word_out_temp,strcat('abl',{exception}));
        if length(exception2)>0
            word_out_temp=regexprep(word_out_temp,strcat(exception2,'$'),'');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        end
        [~, ~,exception2]=SNLP_getLongestException(R2,word_out_temp,strcat('iqU',{exception}));
        if length(exception2)>0
            word_out_temp=regexprep(word_out_temp,strcat(exception2,'$'),'');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        end
        [~, ~,exception2]=SNLP_getLongestException(RV,word_out_temp,strcat('ièr',{exception}));
        if length(exception2)>0
            word_out_temp=regexprep(word_out_temp,strcat(exception2,'$'),'i');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        end
        [~, ~,exception2]=SNLP_getLongestException(RV,word_out_temp,strcat('Ièr',{exception}));
        if length(exception2)>0
            word_out_temp=regexprep(word_out_temp,strcat(exception2,'$'),'i');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        end
        word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
        [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
    end
end

%%%%step1g
if(modifications_step1==0)
    [~, ~,exception]=SNLP_getLongestException(R2,word_out_temp,french_suffix_step1g);
    if length(exception)>0
        if (debug==1);disp(sprintf('STEP 1G'));end
        modifications_step1=1;
        word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
        [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        
        [~, ~,exception]=SNLP_getLongestException(R2,word_out_temp,{'abil'});
        if length(exception)>0
            modifications_step1=1;
            word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        else
            [~, ~,exception]=SNLP_getLongestException(R1,word_out_temp,{'abil'});
            if length(exception)>0
                modifications_step1=1;
                word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'abl');
                [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
            end
        end
        
        [~, ~,exception]=SNLP_getLongestException(R2,word_out_temp,{'ic'});
        if length(exception)>0
            modifications_step1=1;
            word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        else
            [~, ~,exception]=SNLP_getLongestException(R1,word_out_temp,{'ic'});
            if length(exception)>0
                modifications_step1=1;
                word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'iqU');
                [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
            end
        end
        
        [~, ~,exception]=SNLP_getLongestException(R2,word_out_temp,{'iv'});
        if length(exception)>0
            modifications_step1=1;
            word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        end
    end
end

%%%%step1h
if(modifications_step1==0)
    [~, ~,exception]=SNLP_getLongestException(R2,word_out_temp,french_suffix_step1h);
    if length(exception)>0
        if (debug==1);disp(sprintf('STEP 1H'));end
        modifications_step1=1;
        word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
        [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        
        [~, ~,exception]=SNLP_getLongestException(R2,word_out_temp,{'at'});
        if length(exception)>0
            modifications_step1=1;
            word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
            
            [~, ~,exception]=SNLP_getLongestException(R2,word_out_temp,{'ic'});
            if length(exception)>0
                modifications_step1=1;
                word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
                [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
            else
                [~, ~,exception]=SNLP_getLongestException(R1,word_out_temp,{'ic'});
                if length(exception)>0
                    modifications_step1=1;
                    word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'iqU');
                    [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
                end
            end
            
        end
    end
end

%%%%step1i
if(modifications_step1==0)
    [~, ~,exception]=SNLP_getLongestException(word_out_temp,word_out_temp,{'eaux'});
    if length(exception)>0
        if (debug==1);disp(sprintf('STEP 1i'));end
        modifications_step1=1;
        word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'eau');
        [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
    end
end

%%%%step1l
if(modifications_step1==0)
    [~, ~,exception]=SNLP_getLongestException(R1,word_out_temp,{'aux'});
    if length(exception)>0
        if (debug==1);disp(sprintf('STEP 1L'));end
        modifications_step1=1;
        word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'al');
        [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
    end
end

%%%%step1m
if(modifications_step1==0)
    [~, ~,exception]=SNLP_getLongestException(R2,word_out_temp,french_suffix_step1m);
    if length(exception)>0
        if (debug==1);disp(sprintf('STEP 1M'));end
        modifications_step1=1;
        word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
        [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
    else
        [~, ~,exception]=SNLP_getLongestException(R1,word_out_temp,french_suffix_step1m);
        if length(exception)>0
            if (debug==1);disp(sprintf('STEP 1M'));end
            modifications_step1=1;
            word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'eux');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        end
    end
end


%%%%step1o
if(modifications_step1==0)
    [~, ~,exception]=SNLP_getLongestException(RV,word_out_temp,{'amment'});
    if length(exception)>0
        if (debug==1);disp(sprintf('STEP 1O'));end
        modifications_step1=1;
        word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'ant');
        [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        goto_step2a=1;
    end
end

%%%%step1p
if(modifications_step1==0)
    [~, ~,exception]=SNLP_getLongestException(RV,word_out_temp,{'emment'});
    if length(exception)>0
        if (debug==1);disp(sprintf('STEP 1P'));end
        modifications_step1=1;
        word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'ent');
        [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        goto_step2a=1;
    end
end

%%%%step1q
if(modifications_step1==0)
    [RV_position, word_position ,exception]=SNLP_getLongestException(RV,word_out_temp,french_suffix_step1q);
    if length(exception)>0
        if (debug==1);disp(sprintf('STEP 1Q'));end
        RV_mask_vowels = regexp(RV,french_vowels);
        if(RV_position(1)>=2)
            if sum(RV_mask_vowels==(RV_position(1)-1))==1
                modifications_step1=1;
                word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
                [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
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
    [RV_position, word_position ,exception]=SNLP_getLongestException(RV,word_out_temp,french_suffix_step2a);
    if length(exception)>0
        RV_mask_vowels = regexp(RV,french_vowels_extra);
        if(RV_position(1)>=2)
            if sum(RV_mask_vowels==(RV_position(1)-1))==0
                goto_step2b=0;
                modifications_step2a=1;
                word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
                [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
            end
        end
    end
end


if (modifications_step2a==0 & goto_step2b==1)
    %%%%step2b2
    if(modifications_step2b==0)
        [~, ~,exception]=SNLP_getLongestException(RV,word_out_temp,french_suffix_step2b2);
        if length(exception)>0
            if (debug==1);disp(sprintf('STEP 2B2'));end
            modifications_step2b=1;
            word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        end
    end
    
    %%%%step2b1
    [~, ~,exception]=SNLP_getLongestException(R2,word_out_temp,{'ions'});
    if length(exception)>0
        if (debug==1);disp(sprintf('STEP 2B1'));end
        modifications_step2b=1;
        word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
        [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
    end
    
    %%%%step2b3
    if(modifications_step2b==0)
        [~, ~,exception]=SNLP_getLongestException(RV,word_out_temp,french_suffix_step2b3);
        if length(exception)>0
            if (debug==1);disp(sprintf('STEP 2B3'));end
            modifications_step2b=1;
            word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
            [~, ~,exception]=SNLP_getLongestException(RV,word_out_temp,{'e'});
            if length(exception)>0
                word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
                [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
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
    [~, ~,exception]=SNLP_getLongestException(word_out_temp,word_out_temp,{'Y'});
    if length(exception)>0
        word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'i');
        [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        modifications_step3=1;
    end
    [~, ~,exception]=SNLP_getLongestException(word_out_temp,word_out_temp,{'ç'});
    if length(exception)>0
        word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'c');
        [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        modifications_step3=1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%STEP4
%%%%%%%%%%%%%%%%%%%%%%%%
if (modifications_step1==0 & modifications_step2a==0 & modifications_step2b==0)
    if (debug==1);disp(sprintf('STEP 4'));end
    [~, ~,exception]=SNLP_getLongestException(word_out_temp,word_out_temp,{'s'});
    if length(exception)>0
        remove_end_s=1;
        [~, ~,exception]=SNLP_getLongestException(word_out_temp,word_out_temp,french_suffix_step4a);
        if length(exception)>0
            remove_end_s=0;
        end
        [~, ~,exception]=SNLP_getLongestException(word_out_temp,word_out_temp,{'His'});
        if length(exception)>0
            remove_end_s=1;
        end
        if(remove_end_s==1)
            word_out_temp=regexprep(word_out_temp,'s$','');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        end
    end
    
    
    [~, ~,exception]=SNLP_getLongestException(R2,word_out_temp,{'ion'});
    if length(exception)>0
        [~, ~,exception]=SNLP_getLongestException(RV,word_out_temp,{'sion'});
        if length(exception)>0
            word_out_temp=regexprep(word_out_temp,'ion$','');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        else
            [~, ~,exception]=SNLP_getLongestException(RV,word_out_temp,{'tion'});
            if length(exception)>0
                word_out_temp=regexprep(word_out_temp,'ion$','');
                [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
            end
        end
    end
    
    if(length(RV)>=3)
        [~, ~,exception]=SNLP_getLongestException(RV,word_out_temp,french_suffix_step4b);
        if length(exception)>0
            word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'i');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        end
    end
    
    if(length(RV)>=1)
        [~, ~,exception]=SNLP_getLongestException(RV,word_out_temp,{'e'});
        if length(exception)>0
            word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'');
            [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
        end
    end
    
end


%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%Final steps
%%%%%%%%%%%%%%%%%%%%%%%%

[~, ~,exception]=SNLP_getLongestException(word_out_temp,word_out_temp,{'enn'});
if length(exception)>0
    if (debug==1);disp(sprintf('FINAL STEPS'));end
    word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'en');
    [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
end

[~, ~,exception]=SNLP_getLongestException(word_out_temp,word_out_temp,{'onn'});
if length(exception)>0
    if (debug==1);disp(sprintf('FINAL STEPS'));end
    word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'on');
    [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
end

[~, ~,exception]=SNLP_getLongestException(word_out_temp,word_out_temp,{'ett'});
if length(exception)>0
    if (debug==1);disp(sprintf('FINAL STEPS'));end
    word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'et');
    [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
end

[~, ~,exception]=SNLP_getLongestException(word_out_temp,word_out_temp,{'ell'});
if length(exception)>0
    if (debug==1);disp(sprintf('FINAL STEPS'));end
    word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'el');
    [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
end

[~, ~,exception]=SNLP_getLongestException(word_out_temp,word_out_temp,{'eill'});
if length(exception)>0
    if (debug==1);disp(sprintf('FINAL STEPS'));end
    word_out_temp=regexprep(word_out_temp,strcat(exception,'$'),'eil');
    [R1,R2,RV]=SNLP_getR1R2(word_out_temp, 'fra');
end


expression=strcat('é([',french_consonants,']+$)');
word_out_temp = regexprep(word_out_temp,expression,'e$1');

expression=strcat('è([',french_consonants,']+$)');
word_out_temp = regexprep(word_out_temp,expression,'e$1');

word_out_temp = regexprep(word_out_temp,'I','i');
word_out_temp = regexprep(word_out_temp,'U','u');
word_out_temp = regexprep(word_out_temp,'Y','y');

word_out_temp = regexprep(word_out_temp,'He','ë');
word_out_temp = regexprep(word_out_temp,'Hi','ï');
word_out_temp = regexprep(word_out_temp,'H','');


word_out=word_out_temp;
end

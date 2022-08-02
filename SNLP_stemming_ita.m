function word_out_final = SNLP_stemming_ita(word_in)
%%%vers 0.1

debug=0;
italian_vowels='[aeiouàèìòù]';
italian_suffix_step0={'ci'   'gli'   'la'   'le'   'li'   'lo'   'mi'   'ne'   'si'   'ti'   'vi'   'sene'   'gliela'   'gliele'   'glieli'   'glielo'   'gliene'   'mela'   'mele'   'meli'   'melo'   'mene'   'tela'   'tele'   'teli'   'telo'   'tene'   'cela'   'cele'   'celi'   'celo'   'cene'   'vela'   'vele'   'veli'   'velo'   'vene'};
italian_suffix_step1a={'anza'   'anze'   'ico'   'ici'   'ica'   'ice'   'iche'   'ichi'   'ismo'   'ismi'   'abile'   'abili'   'ibile'   'ibili'   'ista'   'iste'   'isti'   'istà'   'istè'   'istì'   'oso'   'osi'   'osa'   'ose'   'mente'   'atrice'   'atrici'   'ante'   'anti'};
italian_suffix_step1b={'azione'   'azioni'   'atore'   'atori'  'icazione'   'icazioni'   'icatore'   'icatori'};
italian_suffix_step1c={'logia'   'logie'};
italian_suffix_step1d={'uzione'   'uzioni'   'usione'   'usioni'};
italian_suffix_step1e={'enza'   'enze'};
italian_suffix_step1f={'amento'   'amenti'   'imento'   'imenti'};
italian_suffix_step1ga={'amente'};
italian_suffix_step1gb={'ivamente' 'ativamente' 'osamente' 'icamente' 'abilamente'};
italian_suffix_step1h={'ità' 'abilità' 'icità' 'ività'};
italian_suffix_step1i={'ivo'   'ivi'   'iva'   'ive' 'ativo'   'ativi'   'ativa'   'ative' 'icativo'   'icativi'   'icativa'   'icative' };
italian_suffix_step2={'ammo' 'ando' 'ano' 'are' 'arono' 'asse' 'assero' 'assi' 'assimo' 'ata' 'ate' 'ati' 'ato' 'ava' 'avamo' 'avano' 'avate' 'avi' 'avo' 'emmo' 'enda' 'ende' 'endi' 'endo' 'erà' 'erai' 'eranno' 'ere' 'erebbe' 'erebbero' 'erei' 'eremmo' 'eremo' 'ereste' 'eresti' 'erete' 'erò' 'erono' 'essero' 'ete' 'eva' 'evamo' 'evano' 'evate' 'evi' 'evo' 'Yamo' 'iamo' 'immo' 'irà' 'irai' 'iranno' 'ire' 'irebbe' 'irebbero' 'irei' 'iremmo' 'iremo' 'ireste' 'iresti' 'irete' 'irò' 'irono' 'isca' 'iscano' 'isce' 'isci' 'isco' 'iscono' 'issero' 'ita' 'ite' 'iti' 'ito' 'iva' 'ivamo' 'ivano' 'ivate' 'ivi' 'ivo' 'ono' 'uta' 'ute' 'uti' 'uto' 'ar' 'ir'};
italian_suffix_step3={ 'a' 'e' 'i' 'o' 'à' 'è' 'ì' 'ò', 'ia' 'ie' 'ii' 'io' 'ià' 'iè' 'iì' 'iò'};

word_out=lower(word_in);
%word_out=SNLP_removePunctuation(word_out);
%word_out=SNLP_removeSpaces(word_out);

%0) Return short words.
if length(word_out)<=2
word_out_final=word_out;
return 
end

%SNOWBALL ITA
%%%%%PRELUDE
%1) replace all acute accents by grave accents
word_out = regexprep(word_out,'á','à');
word_out = regexprep(word_out,'é','è');
word_out = regexprep(word_out,'í','ì');
word_out = regexprep(word_out,'ó','ò');
word_out = regexprep(word_out,'ú','ù');

%first possible output
word_out_final=word_out;

%2)put u after q, and u, i between vowels into upper case
word_out = regexprep(word_out,'qu','qU');
expression=strcat('([',italian_vowels,'])u([',italian_vowels,'])');
word_out = regexprep(word_out,expression,'$1U$2');
expression=strcat('([',italian_vowels,'])i([',italian_vowels,'])');
word_out = regexprep(word_out,expression,'$1I$2');

%%%%%MARK REGIONS
%3)defining R1, R2 (see the note on R1 and R2) and RV 
%in Italian i between two other vowels is not a vowel!!!
%replace consonants/vowels with 0/1
%the word must be in lowercase here!

R1='';
R2='';
RV='';

if(length(word_out)>3)

word_out_mask=zeros(length(word_out),1);
word_out_mask_vowel = regexp(word_out,italian_vowels);
word_out_mask(word_out_mask_vowel)=1;
vowels=find(word_out_mask==1);
consonants=find(word_out_mask==0);

if(numel(vowels)>0 & numel(consonants)>0)
first_vowel=vowels(1);
first_consonant=find(consonants>first_vowel);
if(numel(first_consonant)>0)
first_consonant=consonants(first_consonant(1));
if(first_consonant<length(word_out))
R1=word_out(first_consonant+1:end);
end
end
end

if(debug==1); disp(sprintf('R1: %s',R1));end

if(length(R1)>2)
R1_mask=zeros(length(R1),1);
R1_mask_vowel = regexp(R1,italian_vowels);
R1_mask(R1_mask_vowel)=1;
R1_vowels=find(R1_mask==1);
R1_consonants=find(R1_mask==0);
if(numel(R1_vowels)>0 & numel(R1_consonants)>0)
first_R1_vowel=R1_vowels(1);
first_R1_consonant=find(R1_consonants>first_R1_vowel);
if(numel(first_R1_consonant)>0)
first_R1_consonant=R1_consonants(first_R1_consonant(1));
if(first_R1_consonant<length(R1))
R2=R1(first_R1_consonant+1:end);
end
end
end
end

if(debug==1); disp(sprintf('R2: %s',R2));end


%indentical to the SPANISH stemmer

if(word_out_mask(2)==0)
first_vowel=find(vowels>2);
if(numel(first_vowel)>0 & length(word_out)>(first_vowel(1)+1))
RV=word_out(vowels(first_vowel(1))+1:end);
end
end

if(word_out_mask(1)==1 & word_out_mask(2)==1)
first_consonants=find(consonants>2);
if(numel(first_consonants)>0 & length(word_out)>(first_consonants(1)+1))
RV=word_out(consonants(first_consonants(1))+1:end);
end
end

if(word_out_mask(1)==0 & word_out_mask(2)==1)
if(length(word_out)>3)
RV=word_out(4:end);
end
end

if(debug==1); disp(sprintf('RV: %s',RV));end

end %% word length>3


%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%And now, start the stemming for real!!!
%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%STEP0
%%%%%%%%%%%%%%%%%%%%%%%%
if(length(RV)>=4)
suffix_size=nan(numel(italian_suffix_step0),1);
for i=1:numel(italian_suffix_step0)
suffix_pos=regexp(RV,strcat(italian_suffix_step0{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);

if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step0 più lungo: %s',italian_suffix_step0{suffix_size_min_indx}));end
radix4='';
radix2='';
if(suffix_size_min>4)
radix4=RV(suffix_size_min-4:suffix_size_min-1);
if strcmp(radix4,'ando') | strcmp(radix4,'endo')
if(debug==1); disp(sprintf('Radice di size4: %s',radix4));end
word_out=regexprep(word_out,strcat(italian_suffix_step0{suffix_size_min_indx},'$'),'');
RV=regexprep(RV,strcat(italian_suffix_step0{suffix_size_min_indx},'$'),'');
R1=regexprep(R1,strcat(italian_suffix_step0{suffix_size_min_indx},'$'),'');
R2=regexprep(R2,strcat(italian_suffix_step0{suffix_size_min_indx},'$'),'');
end
end

if(suffix_size_min>2)
radix2=RV(suffix_size_min-2:suffix_size_min-1);
if strcmp(radix2,'ar') | strcmp(radix2,'er') | strcmp(radix2,'ir')
if(debug==1); disp(sprintf('Radice di size2: %s',radix2));end
word_out=regexprep(word_out,strcat(italian_suffix_step0{suffix_size_min_indx},'$'),'e');
RV=regexprep(RV,strcat(italian_suffix_step0{suffix_size_min_indx},'$'),'e');
R1=regexprep(R1,strcat(italian_suffix_step0{suffix_size_min_indx},'$'),'e');
R2=regexprep(R2,strcat(italian_suffix_step0{suffix_size_min_indx},'$'),'e');
end
end
word_out_final=word_out;
end
end 


%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%STEP1
%%%%%%%%%%%%%%%%%%%%%%%%
modifications_step1=0;

%%%%step1a
if(length(R2)>=3)
suffix_size=nan(numel(italian_suffix_step1a),1);
for i=1:numel(italian_suffix_step1a)
suffix_pos=regexp(R2,strcat(italian_suffix_step1a{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);
if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step1a più lungo: %s',italian_suffix_step1a{suffix_size_min_indx}));end
word_out=regexprep(word_out,strcat(italian_suffix_step1a{suffix_size_min_indx},'$'),'');
R2=regexprep(R2,strcat(italian_suffix_step1a{suffix_size_min_indx},'$'),'');
RV=regexprep(RV,strcat(italian_suffix_step1a{suffix_size_min_indx},'$'),'');
R1=regexprep(R1,strcat(italian_suffix_step1a{suffix_size_min_indx},'$'),'');
word_out_final=word_out;
modifications_step1=modifications_step1+1;
end
end

%%%%step1b
if(length(R2)>=5)
suffix_size=nan(numel(italian_suffix_step1b),1);
for i=1:numel(italian_suffix_step1b)
suffix_pos=regexp(R2,strcat(italian_suffix_step1b{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);
if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step1b più lungo: %s',italian_suffix_step1b{suffix_size_min_indx}));end
word_out=regexprep(word_out,strcat(italian_suffix_step1b{suffix_size_min_indx},'$'),'');
R2=regexprep(R2,strcat(italian_suffix_step1b{suffix_size_min_indx},'$'),'');
RV=regexprep(RV,strcat(italian_suffix_step1b{suffix_size_min_indx},'$'),'');
R1=regexprep(R1,strcat(italian_suffix_step1b{suffix_size_min_indx},'$'),'');
word_out_final=word_out;
modifications_step1=modifications_step1+1;
end
end

%%%%step1c
if(length(R2)>=5)
suffix_size=nan(numel(italian_suffix_step1c),1);
for i=1:numel(italian_suffix_step1c)
suffix_pos=regexp(R2,strcat(italian_suffix_step1c{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);
if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step1c più lungo: %s',italian_suffix_step1c{suffix_size_min_indx}));end
word_out=regexprep(word_out,strcat(italian_suffix_step1c{suffix_size_min_indx},'$'),'log');
R2=regexprep(R2,strcat(italian_suffix_step1c{suffix_size_min_indx},'$'),'log');
RV=regexprep(RV,strcat(italian_suffix_step1c{suffix_size_min_indx},'$'),'log');
R1=regexprep(R1,strcat(italian_suffix_step1c{suffix_size_min_indx},'$'),'log');
word_out_final=word_out;
modifications_step1=modifications_step1+1;
end
end

%%%%step1d
if(length(R2)>=6)
suffix_size=nan(numel(italian_suffix_step1d),1);
for i=1:numel(italian_suffix_step1d)
suffix_pos=regexp(R2,strcat(italian_suffix_step1d{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);
if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step1d più lungo: %s',italian_suffix_step1d{suffix_size_min_indx}));end
word_out=regexprep(word_out,strcat(italian_suffix_step1d{suffix_size_min_indx},'$'),'u');
R2=regexprep(R2,strcat(italian_suffix_step1d{suffix_size_min_indx},'$'),'u');
RV=regexprep(RV,strcat(italian_suffix_step1d{suffix_size_min_indx},'$'),'u');
R1=regexprep(R1,strcat(italian_suffix_step1d{suffix_size_min_indx},'$'),'u');
word_out_final=word_out;
modifications_step1=modifications_step1+1;
end
end

%%%%step1e
if(length(R2)>=4)
suffix_size=nan(numel(italian_suffix_step1e),1);
for i=1:numel(italian_suffix_step1e)
suffix_pos=regexp(R2,strcat(italian_suffix_step1e{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);
if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step1e più lungo: %s',italian_suffix_step1e{suffix_size_min_indx}));end
word_out=regexprep(word_out,strcat(italian_suffix_step1e{suffix_size_min_indx},'$'),'ente');
R2=regexprep(R2,strcat(italian_suffix_step1e{suffix_size_min_indx},'$'),'ente');
RV=regexprep(RV,strcat(italian_suffix_step1e{suffix_size_min_indx},'$'),'ente');
R1=regexprep(R1,strcat(italian_suffix_step1e{suffix_size_min_indx},'$'),'ente');
word_out_final=word_out;
modifications_step1=modifications_step1+1;
end
end

%%%%step1f
if(length(RV)>=6)
suffix_size=nan(numel(italian_suffix_step1f),1);
for i=1:numel(italian_suffix_step1f)
suffix_pos=regexp(RV,strcat(italian_suffix_step1f{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);
if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step1f più lungo: %s',italian_suffix_step1f{suffix_size_min_indx}));end
word_out=regexprep(word_out,strcat(italian_suffix_step1f{suffix_size_min_indx},'$'),'');
R2=regexprep(R2,strcat(italian_suffix_step1f{suffix_size_min_indx},'$'),'');
RV=regexprep(RV,strcat(italian_suffix_step1f{suffix_size_min_indx},'$'),'');
R1=regexprep(R1,strcat(italian_suffix_step1f{suffix_size_min_indx},'$'),'');
word_out_final=word_out;
modifications_step1=modifications_step1+1;
end
end

%%%%step1ga
if(length(R1)>=6)
suffix_size=nan(numel(italian_suffix_step1ga),1);
for i=1:numel(italian_suffix_step1ga)
suffix_pos=regexp(R1,strcat(italian_suffix_step1ga{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);
if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step1ga più lungo: %s',italian_suffix_step1ga{suffix_size_min_indx}));end
word_out=regexprep(word_out,strcat(italian_suffix_step1ga{suffix_size_min_indx},'$'),'');
R1=regexprep(R1,strcat(italian_suffix_step1ga{suffix_size_min_indx},'$'),'');
R2=regexprep(R2,strcat(italian_suffix_step1ga{suffix_size_min_indx},'$'),'');
RV=regexprep(RV,strcat(italian_suffix_step1ga{suffix_size_min_indx},'$'),'');
word_out_final=word_out;
modifications_step1=modifications_step1+1;
end
end

%%%%step1gb
if(length(R2)>=8)
suffix_size=nan(numel(italian_suffix_step1gb),1);
for i=1:numel(italian_suffix_step1gb)
suffix_pos=regexp(R2,strcat(italian_suffix_step1gb{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);
if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step1gb più lungo: %s',italian_suffix_step1gb{suffix_size_min_indx}));end
word_out=regexprep(word_out,strcat(italian_suffix_step1gb{suffix_size_min_indx},'$'),'');
R2=regexprep(R2,strcat(italian_suffix_step1gb{suffix_size_min_indx},'$'),'');
RV=regexprep(RV,strcat(italian_suffix_step1gb{suffix_size_min_indx},'$'),'');
R1=regexprep(R1,strcat(italian_suffix_step1gb{suffix_size_min_indx},'$'),'');
word_out_final=word_out;
modifications_step1=modifications_step1+1;
end
end

%%%%step1h
if(length(R2)>=3)
suffix_size=nan(numel(italian_suffix_step1h),1);
for i=1:numel(italian_suffix_step1h)
suffix_pos=regexp(R2,strcat(italian_suffix_step1h{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);
if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step1h più lungo: %s',italian_suffix_step1h{suffix_size_min_indx}));end
word_out=regexprep(word_out,strcat(italian_suffix_step1h{suffix_size_min_indx},'$'),'');
R2=regexprep(R2,strcat(italian_suffix_step1h{suffix_size_min_indx},'$'),'');
RV=regexprep(RV,strcat(italian_suffix_step1h{suffix_size_min_indx},'$'),'');
R1=regexprep(R1,strcat(italian_suffix_step1h{suffix_size_min_indx},'$'),'');
word_out_final=word_out;
modifications_step1=modifications_step1+1;
end
end

%%%%step1i
if(length(R2)>=3)
suffix_size=nan(numel(italian_suffix_step1i),1);
for i=1:numel(italian_suffix_step1i)
suffix_pos=regexp(R2,strcat(italian_suffix_step1i{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);
if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step1h più lungo: %s',italian_suffix_step1i{suffix_size_min_indx}));end
word_out=regexprep(word_out,strcat(italian_suffix_step1i{suffix_size_min_indx},'$'),'');
R2=regexprep(R2,strcat(italian_suffix_step1i{suffix_size_min_indx},'$'),'');
RV=regexprep(RV,strcat(italian_suffix_step1i{suffix_size_min_indx},'$'),'');
R1=regexprep(R1,strcat(italian_suffix_step1i{suffix_size_min_indx},'$'),'');
word_out_final=word_out;
modifications_step1=modifications_step1+1;
end
end


%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%STEP2
%%%%%%%%%%%%%%%%%%%%%%%%

if(modifications_step1==0)

if(length(RV)>=2)
suffix_size=nan(numel(italian_suffix_step2),1);
for i=1:numel(italian_suffix_step2)
suffix_pos=regexp(RV,strcat(italian_suffix_step2{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);
if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step2 più lungo: %s',italian_suffix_step2{suffix_size_min_indx}));end
word_out=regexprep(word_out,strcat(italian_suffix_step2{suffix_size_min_indx},'$'),'');
RV=regexprep(RV,strcat(italian_suffix_step2{suffix_size_min_indx},'$'),'');
R1=regexprep(R1,strcat(italian_suffix_step2{suffix_size_min_indx},'$'),'');
R2=regexprep(R2,strcat(italian_suffix_step2{suffix_size_min_indx},'$'),'');
word_out_final=word_out;
end
end

end


%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%STEP3
%%%%%%%%%%%%%%%%%%%%%%%%

if(length(RV)>=1)
suffix_size=nan(numel(italian_suffix_step3),1);
for i=1:numel(italian_suffix_step3)
suffix_pos=regexp(RV,strcat(italian_suffix_step3{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);
if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step3 più lungo: %s',italian_suffix_step3{suffix_size_min_indx}));end
word_out=regexprep(word_out,strcat(italian_suffix_step3{suffix_size_min_indx},'$'),'');
word_out_final=word_out;
end
end


if(length(RV)>=1)
suffix_pos=regexp(word_out,'ch$');
if(suffix_pos>0)
word_out=regexprep(word_out,'ch$','c');
word_out_final=word_out;
end
end

if(length(RV)>=1)
suffix_pos=regexp(word_out,'gh$');
if(suffix_pos>0)
word_out=regexprep(word_out,'gh$','g');
word_out_final=word_out;
end
end

word_out = regexprep(word_out,'U','u');
word_out = regexprep(word_out,'I','i');
word_out_final=word_out;


end

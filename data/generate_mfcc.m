%this script will crawl the MFCC data from VoxForge to generate the en_de_it.mat file 
%containing MFCCs for the three languages english, deutsch and italian.
%this file assumes VoiceBox is in your Octave/Matlab's path.

en_endpoint = 'http://www.repository.voxforge1.org/downloads/SpeechCorpus/Trunk/Audio/MFCC/8kHz_16bit/MFCC_0_D/';
de_endpoint = 'http://www.repository.voxforge1.org/downloads/de/Trunk/Audio/MFCC/8kHz_16bit/MFCC_0_D/';
it_endpoint = 'http://www.repository.voxforge1.org/downloads/it/Trunk/Audio/MFCC/8kHz_16bit/MFCC_0_D/';
endpoint = it_endpoint;
limit = 1500;

flist = urlread(endpoint);

[s,e] = regexp(flist, ">([a-zA-Z0-9]*-[a-zA-Z0-9]*)+\.tgz<");
%truncate the amount of data to be crawled
s = s(1:min(limit, size(s,2)));
e = e(1:min(limit, size(s,2)));

confirm_recursive_rmdir(0)
filename = "it.mat";

function data = fetch_data(flist, endpoint, anfang, ende, id)
	%print(int2str(id));
    %at each step fetch a file from the corpus
	currfile = flist(anfang + 1: ende - 1);
	currdir = strcat("temp", int2str(id));
     
	mkdir(currdir);cd(currdir);
    data = zeros(26, 1);
	status = urlwrite(strcat(endpoint, currfile), currfile);
 	
    read_size = 0;
    %Unzip the mfc files to temp dir and add them to the dataset.
    %TODO: only working in Linux?.
    untar(currfile); cd(currfile(1:end-4)); cd mfc;
    mfcs = ls("*.mfc");
    for j=1:size(mfcs,1)
        [d,fp,dt,tc,t]=readhtk(strtrim(mfcs(j, :)));
	    %check if this file contains mfccs.
	    if dt!=6 
	        continue 
	    else	
            %read_size = read_size + size(d, 1);
            data = [data, d'];
		end
	end
    cd ../../..
	rmdir(currdir, "s");
end

%here goes what to put in the output when the function fails.
function retcode = eh(error)
    a = error
    retcode = zeros(26,1).+255;	
end


mfccs = pararrayfun(numWorkers = 30,
                    @(anfang, ende, id)fetch_data(flist, endpoint, anfang, ende, id), %currying with anonym funct
                    s, e, 1:size(s,2), %parameters for the function
                    "ErrorHandler" , @eh);

read_size = size(mfccs)
save("-mat4-binary", filename, "mfccs");
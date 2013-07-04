%this script will crawl the MFCC data from VoxForge to generate the en_de_it.mat file 
%containing MFCCs for the three languages english, deutsch and italian.
%this file assumes VoiceBox is in your Octave/Matlab's path.

en_endpoint = 'http://www.repository.voxforge1.org/downloads/SpeechCorpus/Trunk/Audio/MFCC/8kHz_16bit/MFCC_0_D/'
de_endpoint = 'http://www.repository.voxforge1.org/downloads/de/Trunk/Audio/MFCC/8kHz_16bit/MFCC_0_D/'
it_endpoint = 'http://www.repository.voxforge1.org/downloads/it/Trunk/Audio/MFCC/8kHz_16bit/MFCC_0_D/'

list = urlread(en_endpoint);
[s,e] = regexp(list, ">([a-zA-Z0-9]*-[a-zA-Z0-9]*)+\.tgz<");
confirm_recursive_rmdir(0)
filename = 'en_de_it.mat';
%TODO: remove crapy hardcoded stuff
data = zeros(1,26);

for i=1:size(s,2)
    %at each step fetch a file from the corpus
	mkdir temp;
	currfile = list(s(1): e(1))(2:end-1);
	urlwrite(strcat(en_endpoint, currfile), strcat("./temp/", currfile));
	
    read_size = 0;
	%Unzip the mfc files to temp dir and add them to the dataset.
	%TODO: only working in Linux.
	
	cd temp; untar(currfile); cd(currfile(1:end-4)); cd mfc;
	mfcs = ls("*.mfc");
	for j=1:size(mfcs,1)
	    [d,fp,dt,tc,t]=readhtk(mfcs(j, :));
		%check if this file contains mfccs.
		if dt!=6 
		    continue 
		else	
            read_size = read_size + size(d, 1);
			data = [data; d];
		end
	end
	cd("../../..");
	rmdir("./temp/");
end
read_size
save filename data
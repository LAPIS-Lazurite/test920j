#! /usr/bin/ruby

files = Dir.glob("./log/*")

def get_id(fpath)
	fname = File.basename(fpath)
	if File.extname(fname) == ".log" then
		id = File.basename(fname,".log").split("_")[1]
	else
		id = 0
	end
	return id
end

def search_Attenuate(line) 
	data = line.split(" ") 
	if (data[6]=="Result:") then
		return data[7].delete("dBm").to_f
	else
		return nil
	end
end
def search_FrequencyCounter(line)
	data = line.split(" ") 
	if ((data[6]=="Frequency")&&(data[7] == "counter:")) then
		return data[8].to_i
	else
		return nil
	end
end
def search_subject(line)
	data = line.split(" ") 
	if data[6]=="Subject:" then
		return data[7].to_i
	else
		return nil
	end
end

files.each do |fpath|
	id = get_id(fpath)
	freq1 = 0
	freq2 = 0
	freq3 = 0
	att1 = 0
	att2 = 0
	att3 = 0
	begin
		state = 0
		subject = 0
		prev_subject = 0
		state = 0
		File.open(fpath) do |body| 
			body.read.split("\n").each do |line| 
				data = search_subject(line)
				if(data != nil)
					subject = data
					if(prev_subject != subject) then
						prev_subject = subject
						state = 1
					end
					next
				end
				if (subject == 2) && (state == 1) then
					freq = search_FrequencyCounter(line) 
					if freq != nil then
						freq1 = freq
						state = state + 1
						next
					end
				end
				if (subject == 2) && (state == 2) then
					freq = search_FrequencyCounter(line) 
					if freq != nil then
						freq2 = freq
						state = state + 1
						next
					end
				end
				if (subject == 2) && (state == 3) then
					freq = search_FrequencyCounter(line) 
					if freq != nil then
						freq3 = freq
						state = 0
						next
					end
				end
				if (subject == 3) && (state == 1) then
					att = search_Attenuate(line) 
					if att != nil then
						att1 = att
						state = state + 1
						next
					end
				end
				if (subject == 3) && (state == 2) then
					att = search_Attenuate(line) 
					if att != nil then
						att2 = att
						state = state + 1
						next
					end
				end
				if (subject == 3) && (state == 3) then
					att = search_Attenuate(line) 
					if att != nil then
						att3 = att
						state = state + 1
						next
					end
				end
			end
		end
		begin
			printf("%s,",fpath)
			printf("%s,",id)
			printf("%d,",freq1)
			printf("%d,",freq2)
			printf("%d,",freq3)
			printf("%f,",att1)
			printf("%f,",att2)
			printf("%f\n",att3)
		rescue
			p fpath
		end
	end
end

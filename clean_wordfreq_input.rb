
require 'fileutils'


def clean_regexp(t)
        Regexp.compile(t.gsub(/([\.\(\)\[\]\*\+\{\}])/, "\\\1"))
end


def clean_up(content)
        [[/[^A-Za-z,\.:; \/]/, ' '], [/Ä/, 'Ae'], [/Ö/, 'Oe'], [/Ü/, 'Ue'], [/ä/, 'ae'], [/ö/, 'oe'], [/ü/, 'ue']]
        .inject(content) { |mem, map| 
                mem.gsub(map[0], map[1])
        }.downcase
end


def pad(num)
        s = num.to_s
        while s.length < 2
                s = "0#{s}"
        end
        s
end


def replace_dict_entries(txt)
##add dummy word-entries b/c joining terms changes 
##the word count of the doc which is relevant for some metrics
        dummy_num = 0
        res = $DICT.inject(txt) { |t, dict_entry|  
                if (t =~ dict_entry[0])
                        dummy_num += dict_entry[2] - 1
                        t.gsub(dict_entry[0], dict_entry[1]) 
                else
                        t
                end
        } 
        dummy_num.times { 
                res += " llllll"
        }
        res
end


$SRC = 'data/an*/'
$DICT_SRC = 'dict2.txt'


target_num = -1
begin
        target_num += 1
        target = "new_data_#{pad(target_num)}/" 
end while FileTest.exists?(target)


$TARGET = target
FileUtils.mkdir_p($TARGET)


#create a list of dict entries with spaces
$DICT = IO.read($DICT_SRC).split("\n").select { |e| e =~ / / }
                        .map { |e| t = e[1..-2].downcase; [clean_regexp(t), t.gsub(' ', ''), t.split(' ').length] }
                        .sort { |a,b| b[2] <=> a[2] }




Dir["#{$SRC}*"].each { |pa| 


        clean_txt = clean_up(IO.read(pa)) 
        clean_txt = replace_dict_entries(clean_txt)


        pa_parts = pa.split('/')
        pa_name, pa_lastdir = pa_parts[-1], pa_parts[-2]
        target_dir = "#{$TARGET}#{pa_lastdir}/"
        FileUtils.mkdir_p(target_dir)
        File.open("#{target_dir}#{pa_name}", "w+") { |fo| 
                fo << clean_txt 
                fo << "\n"
        }
}

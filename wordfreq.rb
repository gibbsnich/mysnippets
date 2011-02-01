class DocMatrix
        # expects doc_content to be as clean as cleanup_textinput cleans text..
        def initialize(doc_content, words) 
                #@content = clean_up(doc_content).downcase
                @content = doc_content.downcase
                # make sure there is no whitespace around a given word
                @words = words.map { |w| w.strip.downcase.gsub(/([\.\(\)\[\]\*\+\{\}])/, "\\\1") }.select { |w| not w.empty? }
                fill_matrix()
        end             
        
        def fill_matrix
                @values = @words.inject({}) { |h,w| h[w] = @content.scan(Regexp.compile(" #{w} ")).length; h }
                @word_sum = @values.inject(0) { |s, (k,v)| s + v }
                # be even more stricter than clean_textinput and remove digits etc as well
                # for this measure only
                @word_count = @content.gsub(/[^A-Za-z ]/, '').split(' ').length         
        end
                
        def get_index
                @word_sum.to_f / @word_count.to_f
        end
        
        def print_metrics               
                puts "total.cnt = #{@word_sum}"
                puts "idx = #{@word_sum} / #{@word_count} = #{get_index()}"
                puts @values.select { |k,v| v > 0 }.map { |(k,v)| "  #{k} => #{v}" }
        end     
end


def read_dict(dict_path = 'dict3.txt')
        IO.read(dict_path).split("\n").map { |e| e[1..-2].downcase }
end


def run_all
        dict = read_dict()


        Dir["new_data_01/*/*"].each { |pa| 
                puts "#{pa}"
                DocMatrix.new(IO.read(pa), dict).print_metrics
                puts ''
        }
end


run_all



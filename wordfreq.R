library(tm)
##replace comp by tot
computeIndex <- function(corpus, dict) {
        dictDtm <- DocumentTermMatrix(corpus, list(dictionary = dict))
        compDtm <- DocumentTermMatrix(corpus)
        
        for (k in 1:nDocs(compDtm)) {
                docName <- Docs(compDtm)[k]
                dictMatrix <- as.matrix(dictDtm[k])
                dictNames <- colnames(dictDtm[k])
                compMatrix <- as.matrix(compDtm[k])
                
                compLen <- 0
                dictLen <- 0
                
                for (i in 1:length(compMatrix)) {               
                        compLen <- compLen + compMatrix[i]              
                }
                
                for (i in 1:length(dictMatrix)) {
                        dictLen <- dictLen + dictMatrix[i]
                        if (dictMatrix[i] > 0) {
                                cat(sprintf("  '%s' => %s\n", dictNames[i], dictMatrix[i]))
                        }
                }
                                
                cat(sprintf("%s;%s;%s;%s\n", docName, as.character(dictLen), as.character(compLen), as.character(dictLen / compLen)))           
        }       
}


(dictData <- scan(file = "c:\\users\\user\\adir\\dict.txt", what = list("")))
(dict <- Dictionary(array(unlist(dictData))))

(analystTxts <- Corpus(DirSource("c:\\users\\user\\adir\\src_data\\"), readerControl = list(language = "en", load = TRUE)))
computeIndex(analystTxts, dict)



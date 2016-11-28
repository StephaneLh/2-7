function card2code(data::Array{UTF8String})
    
    
    
    comb1bis=['♡' '♢' '♣' '♠']
    comb2bis=['2' '3' '4' '5' '6' '7' '8' '9' 'T' 'J' 'Q' 'K' 'A']
    
    for i=1:n
        out[i] =  string(string(find(data[i][1] .== comb2bis)[1]),"-",string(find(data[i][2] .== comb1bis)[1]))
    end
    
    return out
    
end

comb1=["♡" "♢" "♣" "♠"
        1   2   3   4]

comb2=["2" "3" "4" "5" "6" "7" "8" "9" "T" "J" "Q" "K" "A"
        1   2   3   4   5   6   7   8   9  10  11  12  13]

comb = Array{UTF8String}(2,52)
k    = 1

T = 1500

for i=1:length(comb1[1,:])
    for j=1:length(comb2[1,:])
        comb[1,k]=comb2[1,j]*comb1[1,i]
        comb[2,k]=string(comb2[2,j], "-", comb1[2,i])
        k=k+1
    end
end


hand1 = ["2♡","3♡","4♠","7♣"]
hand2 = ["4♡","5♡","6♢","8♣","9♡"]

hand1_code = card2code(hand1)
hand2_code = card2code(hand2)

comb_test = comb[2,:][:]

discarded_desk = filter(e->e∉[hand1_code;hand2_code],comb_test)

hand2_sort = sort(map(x->parse(Int64,x[1]),hand2_code))

rr = zeros(T)

for j_idx = 1:T
    
# shuffle the desk
idx_rand = randperm(size(discarded_desk,1))

#
discarded_desk1 = discarded_desk[idx_rand]
    
#
hand1_code1 = [hand1_code, discarded_desk1[1]]
    
# 
hand1_sort = sort(map(x->parse(Int64,x[1]),hand1_code1))

# Compare both hands
if any(diff(hand1_sort) .== 0) # check duplicate values
        r = 0
    elseif hand1_sort[5]>hand2_sort[5]
        r = 0
    elseif hand1_sort[5]<hand2_sort[5]
        r = 1
    elseif hand1_sort[5]==hand2_sort[5] && hand1_sort[4]>hand2_sort[4]
        r = 0
    elseif hand1_sort[5]==hand2_sort[5] && hand1_sort[4]<hand2_sort[4]
        r = 1
    elseif hand1_sort[4]==hand2_sort[4] && hand1_sort[3]>hand2_sort[3]
        r = 0
    elseif hand1_sort[4]==hand2_sort[4] && hand1_sort[3]<hand2_sort[3]    
        r = 1    
end # and so on ...
   
    rr[j_idx] = r
    
end


prob = sum(rr)/T


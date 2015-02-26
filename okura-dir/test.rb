require 'okura/serializer'

dict_dir='okura-dic'
tagger=Okura::Serializer::FormatInfo.create_tagger dict_dir

str='三島由紀夫っぽい'

# 文字列から単語候補を計算
nodes=tagger.parse(str)

total_cost = 0

# 単語候補の中で､一番最もらしい組み合わせを選択
nodes.mincost_path.each{|node|
        word = node.word
        # word.surface : 単語の表記
        # word.left.text : 品詞
        # 品詞はword.leftとword.rightがありますが､一般的に使われる辞書(IPA辞書やNAIST辞書)では
        # 両方同じデータが入ってます
        total_cost += word.cost
        puts word.surface + " : " + word.cost.to_s + "-----------------"
        #puts word
}

puts total_cost.to_s + "--------------"

require 'okura/serializer'

dict_dir='okura-dic'
tagger=Okura::Serializer::FormatInfo.create_tagger dict_dir

str='寂しい印象でした。'

# 文字列から単語候補を計算
nodes=tagger.parse(str)

# 単語候補の中で､一番最もらしい組み合わせを選択
nodes.mincost_path.each{|node|
        word = node.word
        # word.surface : 単語の表記
        # word.left.text : 品詞
        # 品詞はword.leftとword.rightがありますが､一般的に使われる辞書(IPA辞書やNAIST辞書)では
        # 両方同じデータが入ってます
        puts word.surface + " : " + word.left.text
}

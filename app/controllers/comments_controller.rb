class CommentsController < ApplicationController
  
  protect_from_forgery with: :null_session
  
  def index
  end

  def register
    require 'okura/serializer'
  
    tagger=Okura::Serializer::FormatInfo.create_tagger 'okura-dir/okura-dic'
  
    @str=params[:impression]
  
    # 文字列から単語候補を計算
    nodes=tagger.parse(@str)
  
    # 単語候補の中で､一番最もらしい組み合わせを選択
    @array = Array.new
    nodes.mincost_path.each{|node|
      word = node.word
      # word.surface : 単語の表記
      # word.left.text : 品詞
      # 品詞はword.leftとword.rightがありますが､一般的に使われる辞書(IPA辞書やNAIST辞書)では
      # 両方同じデータが入ってます
      @array.push(word.surface + " : " + word.left.text)
    }
    
  end
end

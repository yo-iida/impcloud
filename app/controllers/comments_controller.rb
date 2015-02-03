class CommentsController < ApplicationController
  
  protect_from_forgery with: :null_session
  
  def index
  end

  def register
    require 'csv'
    require 'okura/serializer'
    tagger=Okura::Serializer::FormatInfo.create_tagger 'okura-dir/okura-dic'
  
    @str=params[:impression]
  
    # 文字列から単語候補を計算
    nodes=tagger.parse(@str)
  
    # 単語候補の中で､一番最もらしい組み合わせを選択
    @word_array = Array.new
    nodes.mincost_path.each{|node|
      word = node.word
      # word.surface : 単語の表記
      # word.left.text : 品詞
      # 品詞はword.leftとword.rightがありますが､一般的に使われる辞書(IPA辞書やNAIST辞書)では
      # 両方同じデータが入ってます
      @word_array.push(word.surface + "," + word.left.text)
    }
    
    @err = ''
    
    #DBに格納
    comment = Comment.new
    comment.comment = @str
    comment.save
    @word_array.each do |item|
      CSV.parse(item) do |row|
        #BOS/EOSが処理されてNGになるのでこれに対応する処理が必要
        #エラー処理も考慮する必要あり
        if row[1] == '名詞' || row[1] == '形容詞' then
          word = Word.new
          word.word = row[0]
          word.part = row[1]
          word.save
          @err = 'OK'
        else
          @err = 'NG'
        end
      end
    end
    
  end
end

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
      
      # CSV形式にして配列化
      @word_array.push(word.surface + "," + word.left.text)
    }
    
    # 不要な要素の削除
    @word_array.delete("BOS/EOS,BOS/EOS")
    
    # コメントをDBに格納
    comment = Comment.new
    comment.comment = @str
    comment.save
    
    # 単語、品詞をDBに格納
    @word_array.each do |item|
      CSV.parse(item) do |row|
          word = Word.new
          word.word = row[0]
          word.part = row[1]
          word.save
      end
    end
    
    # 表示用アクションにリダイレクト
    redirect_to :action => "show"
    
  end
  
  def show
    comment = Comment.new
    word = Word.new
    
    @comment = Comment.all
    @word = Word.where("part in ('名詞','形容詞','動詞')")
    
    @all_arr = []
    @word.each do |row|
      @all_arr << row.word
    end
    @index_arr = @all_arr.uniq
    
    @count_hash = {}
    @index_arr.each do |row|
      @count_hash[row] = @all_arr.count(row)
    end
    @count_hash.sort_by{|key,val| -val}
    
  end
  
end

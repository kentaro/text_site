defmodule TextSite do
  use ThousandIsland.Handler

  @line_width 30
  @banner """
  ■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□
  ■□ 栗林健太郎のホームページへようこそ！ ■□
  ■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□
  """
  @header """

  最終更新日時 <%= last_modified %>
  あなたは<%= counter %>番目のアクセス人間です！！

  """
  @content """
  # 自己紹介

  GMOペパボ株式会社取締役CTO / 一般社団法人日本CTO協会理事 / 北陸先端科学技術大学院大学博士後期課程 / 情報処理安全確保支援士（登録番号：013258） / 修士（情報科学、北陸先端科学技術大学院大学） / JK1RZR（アマチュア無線） / とうきょうKK256（DCR・LCR）

  ----

  1976年生まれ。幼少期より高校卒業まで奄美大島で過ごす。1995年、東京都立大学法学部に入学。法学部政治学科に進み、日本政治史および行政学を中心に学ぶ。卒業後、数年のブランクを経て2002年に奄美市役所に入所。PHPでブログを自作したことからプログラミングにハマり、HTML/CSSやPerl5のコミュニティを中心にネット上で活動する。

  2008年5月、株式会社はてなにWebアプリケーションエンジニアとして入社。2012年5月、株式会社paperboy&co.（現GMOペパボ株式会社）に技術基盤整備エンジニアとして入社。主にRuby、PHP、Go等を用いた全社的な技術基盤の整備の他、RailsやPHPで書かれたサービスの開発や運用改善にも従事した。また、全社的な開発プロセスの改善にも取り組み、リーンプロセスやスクラムの導入にも寄与した。

  2014年以降は、エンジニアリング組織のマネジメントを担っている。2014年8月、GMOペパボ株式会社の技術責任者に就任しエンジニア組織の再編に取り組む。2015年3月、執行役員CTOに就任し全社的なインフラ基盤の構築等に取り組む。2017年3月、取締役CTOに就任し、技術経営（技術に関わる全社での戦略策定、実行）を担う。また、ペパボ研究所長として研究開発にも携わっている。

  2018年10月、情報処理安全確保支援士として登録（登録番号：013258）。2020年4月より、北陸先端科学技術大学院に在学する社会人学生でもある（2022年3月、博士前期課程を優秀修了。2022年4月より博士後期課程在学中）。IoTシステムの基盤技術とセキュリティ、ElixirやErlang/OTPのIoTシステムへの応用について研究している。

  趣味は読書。歴史、アート、思想等の人文系諸ジャンルや社会科学、情報科学等のサイエンスの諸ジャンルを中心に、書籍を毎年約200冊近く読んでいる（読書記録）。その他、無線（アマチュア無線、ライセンスフリー無線）、アート鑑賞、現代作家のうつわ、江戸前鮨、シーシャ、歌舞伎、落語等を好む。趣味を発信するYouTuberとしても活動。
  """

  @impl ThousandIsland.Handler
  def handle_connection(socket, state) do
    # banner
    socket |> write_chunk(@banner)
    # header
    socket |> write_chunk(make_header())

    # content
    @content
    |> String.split("\n", trim: true)
    |> Enum.each(fn line ->
      line
      |> String.graphemes()
      |> Enum.chunk_every(@line_width)
      |> Enum.each(fn chunk ->
        socket
        |> write_chunk(chunk)
      end)

      socket
      |> write_char("\n")
    end)

    {:close, state}
  end

  defp make_header() do
    {:ok, stat} = File.stat(__ENV__.file)
    last_modified =
      stat.mtime
      |> NaiveDateTime.from_erl!()
      |> DateTime.from_naive!("Asia/Tokyo")
      |> to_string()

    EEx.eval_string(
      @header,
      last_modified: last_modified,
      counter: 1
    )
  end

  defp write_chunk(socket, chunk) when is_binary(chunk) do
    socket
    |> write_chunk(chunk |> String.graphemes())
  end

  defp write_chunk(socket, chunk) do
    chunk
    |> Enum.each(fn char ->
      socket
      |> write_char(char)

      Process.sleep(10)
    end)

    socket
    |> write_char("\n")
  end

  defp write_char(socket, char) do
    socket
    |> ThousandIsland.Socket.send(char)
  end
end


<h1>基礎代謝, カロリー記録アプリ - Caldate</h1>

<img src="https://user-images.githubusercontent.com/43976208/91845212-bb016580-ec93-11ea-913d-2a7c5fd5069f.png" width=20%>




<p>基礎代謝, カロリー記録アプリ - Caldateは日々摂取したカロリーを保存し振り返り確認することで健康状態を確認することができるアプリケーションです。</p>
<p>対応OSはAndroidとiOSになります。</p>
<ui>
    <li><a href="https://play.google.com/store/apps/details?id=com.makotoaoki.Caldate2">android版</a></li>
    <li><a href="https://apps.apple.com/us/app/id1487352735">iOS版</a></li>
</ui>

<h2>機能</h2>
<ui>
    <li><a href="#func1">カロリー保存</a></li>
    <li><a href="#func2">保存したカロリーのグラフ描画</a></li>
    <li>基礎代謝計算</li>
    <li>ご飯のカロリーデータ取得</li>
</ui>

<h3 name="func1">カロリー保存</h3>
<p>記入されたカロリー量を保存します。保存先はアプリ内に作成されたDBに保存されます。DBについては<a href="https://pub.dev/packages/sqflite">sqlite</a>を使用しております。</p>
<p>保存する日にちはスマートフォン端末内の日にちより取得してDBにカロリーと共に保存されます。</p>

<h3 name="func2">保存したカロリーのグラフ描画</h3>
<p>DBに保存されたデータの過去7日分をサマリーとして表示します。グラフの描画には<a href="https://pub.dev/packages/fl_chart">FLChart</a>
を使用しております。</p>

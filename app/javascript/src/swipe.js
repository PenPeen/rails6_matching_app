/**
 * /usersのスワイプ処理を実装する
 * 
 * マッチング画面でのみ実行
 * Hammer.jsを使用
 */
if(location.pathname == "/users" || location.pathname == '/users/') {
    $(function () {

        let allCards = document.querySelectorAll('.swipe--card');
        let swipeContainer = document.querySelector('.swipe');

        /**
         * カードを重ねて表示する。
         * 
         * z-indexの調整、表示位置、透明度の調整
         */ 
        function initCards() {

            // カード一覧取得（スワイプ済みのカードを除く）
            let newCards = document.querySelectorAll('.swipe--card:not(.removed)');

            // カードの属性変更
            newCards.forEach(function (card, index) {
              card.style.zIndex = allCards.length - index;
              card.style.transform = 'scale(' + (20 - index) / 20 + ') translateY(-' + 30 * index + 'px)';
              card.style.opacity = (10 - index) / 10;
            });

            // ユーザーが存在しない場合
            if (newCards.length == 0) {
                $(".no-user").addClass("is-active");
            }

        }

        // 初期化
        initCards();

        /**
         * イベント登録
         */
        allCards.forEach(function (el) {
            // Hammerインスタンス作成
            let hammertime = new Hammer(el);
            
            /**
             * panイベント（要素をクリックした状態での画面操作）
             */
            hammertime.on('pan', function (event) {

            // カードを動かしていない時
            if (event.deltaX === 0) return;
            if (event.center.x === 0 && event.center.y === 0) return;
    
            // 移動中の装飾
            el.classList.add('moving');
    
            // X方向へのスクロール
            swipeContainer.classList.toggle('swipe_like', event.deltaX > 0);
            // -X方向へのスクロール
            swipeContainer.classList.toggle('swipe_dislike', event.deltaX < 0);

            let xMulti = event.deltaX * 0.03;
            let yMulti = event.deltaY / 80;
            let rotate = xMulti * yMulti;
            
            // 要素の配置変更（X軸、Y軸、回転）
            event.target.style.transform = `translate(${event.deltaX}px, ${event.deltaY}px) rotate(${rotate}deg)`;
            // event.target.style.transform = 'translate(' + event.deltaX + 'px, ' + event.deltaY + 'px) rotate(' + rotate + 'deg)';
            });

            /**
             * panendイベント（要素から指を離した時）
             */
            hammertime.on('panend', function (event) {
                // 移動中の装飾削除
                el.classList.remove('moving');

                // クラス削除
                swipeContainer.classList.remove('swipe_like');
                swipeContainer.classList.remove('swipe_dislike');
                
                // 移動量（X軸）の取得
                let keep = Math.abs(event.deltaX) < 200
                // スクロールが200以上であれば、判定済みとする
                event.target.classList.toggle('removed', !keep);
                
                // リアクション判定
                if (keep) {
                    // 元の位置に戻す。
                    event.target.style.transform = '';
                } else {
                    // スクロール方向でリアクション切替
                    let reaction = event.deltaX > 0 ? "like" : "dislike";

                    let moveOutWidth = document.body.clientWidth;
                    let endX = Math.max(Math.abs(event.velocityX) * moveOutWidth, moveOutWidth) + 100;
                    let toX = event.deltaX > 0 ? endX : -endX;
                    let endY = Math.abs(event.velocityY) * moveOutWidth;
                    let toY = event.deltaY > 0 ? endY : -endY;
                    let xMulti = event.deltaX * 0.03;
                    let yMulti = event.deltaY / 80;
                    let rotate = xMulti * yMulti;

                    // Ajax リアクションの送信
                    postReaction(el.id, reaction);
        
                    // 要素を画面外に移動させる
                    event.target.style.transform = `translate(${toX}px, ${(toY + event.deltaY) }px) rotate(${rotate}deg)`;
        
                    initCards();
                }
            });

        });

        // 手動でボタンをクリックした時
        // LIKEボタン
        $('#like').on('click', function() {
            createButtonListener("like");
        })
    
        // NOT LIKEボタン
        $('#dislike').on('click', function() {
            createButtonListener("dislike");
        })

        /**
         * リアクションボタンクリック後の処理
         * 
         * LIKE     右で移動
         * DIS LIKE 左で移動 
         * 
         * @param {*} reaction 
         * @returns 
         */
        function createButtonListener(reaction) {
            let cards = document.querySelectorAll('.swipe--card:not(.removed)');
            if (!cards.length) return false;

            let moveOutWidth = document.body.clientWidth * 2;
            let card = cards[0];

            // Ajaxリアクション送信
            let user_id = card.id;
            postReaction(user_id, reaction);

            card.classList.add('removed');

            // カードの移動
            if (reaction == "like") {
                // X方向へ移動
                card.style.transform = 'translate(' + moveOutWidth + 'px, -100px) rotate(-30deg)';
            } else {
                // -X方向への移動
                card.style.transform = 'translate(-' + moveOutWidth + 'px, -100px) rotate(30deg)';
            }

            // カード初期化
            initCards();
        }

        // Ajax リアクション結果を送信
        function postReaction(user_id, reaction) {
            $.ajax({
                url: "reactions",
                type: "POST",
                datatype: "json",
                data: {
                    user_id: user_id,
                    reaction: reaction,
                }
            })
            .done(function () {
                console.log("done!")
            })
        }
    });
}

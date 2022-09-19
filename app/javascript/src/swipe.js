/**
 * /usersのスワイプ処理を実装する
 * 
 * Hammer.jsを使用
 */

// /usersパスでのみ実行
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

            let newCards = document.querySelectorAll('.swipe--card:not(.removed)');

            newCards.forEach(function (card, index) {
              card.style.zIndex = allCards.length - index;
              card.style.transform = 'scale(' + (20 - index) / 20 + ') translateY(-' + 30 * index + 'px)';
              card.style.opacity = (10 - index) / 10;
            });
          }

        initCards();

        allCards.forEach(function (el) {
            // Hammerインスタンス作成
            let hammertime = new Hammer(el);
            
            /**
             * panイベントの登録（要素をクリックした状態での画面操作）
             */
            hammertime.on('pan', function (event) {

            // カードを動かしていない時
            if (event.deltaX === 0) return;
            if (event.center.x === 0 && event.center.y === 0) return;
    
            el.classList.add('moving');
    
            // クラスの切り替え（操作に紐づくアイコンの表示）  
            swipeContainer.classList.toggle('swipe_like', event.deltaX > 0);
            swipeContainer.classList.toggle('swipe_dislike', event.deltaX < 0);
    
            // 移動距離に応じて表示を変更   
            let xMulti = event.deltaX * 0.03;
            let yMulti = event.deltaY / 80;
            let rotate = xMulti * yMulti;
    
            event.target.style.transform = 'translate(' + event.deltaX + 'px, ' + event.deltaY + 'px) rotate(' + rotate + 'deg)';
            });

            /**
             * panendイベントの登録（要素から指を離した時）
             */
            hammertime.on('panend', function (event) {
                el.classList.remove('moving');

                // アイコン削除
                swipeContainer.classList.remove('swipe_like');
                swipeContainer.classList.remove('swipe_dislike');
        
                let moveOutWidth = document.body.clientWidth;
        
                let keep = Math.abs(event.deltaX) < 200
                event.target.classList.toggle('removed', !keep);
        
                if (keep) {
                event.target.style.transform = '';
            } else {
                let endX = Math.max(Math.abs(event.velocityX) * moveOutWidth, moveOutWidth) + 100;
                let toX = event.deltaX > 0 ? endX : -endX;
                let endY = Math.abs(event.velocityY) * moveOutWidth;
                let toY = event.deltaY > 0 ? endY : -endY;
                let xMulti = event.deltaX * 0.03;
                let yMulti = event.deltaY / 80;
                let rotate = xMulti * yMulti;
    
                event.target.style.transform = 'translate(' + toX + 'px, ' + (toY + event.deltaY) + 'px) rotate(' + rotate + 'deg)';
    
                initCards();
            }
            });

        });
    });
}

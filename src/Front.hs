{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
 
module Front where
import Yesod
import Foundation
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text
import Handlers
import Database.Persist.Postgresql

-- Sempre devemos usar o defaultLayout
-- pois hamlets, lucius, cassius e julius sao
-- da Monad Widget. A funcao defaultLayout
-- transforma Widgets em Handlers
getPag4R :: Handler Html
getPag4R = defaultLayout $ do
    [whamlet|
        <div id="alvo">
           ^{widget1}
    |]

widget1 :: Widget
widget1 = [whamlet|
    <p>
        Parágrafo dentro da div
|]

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    setTitle "Minha página"
    addStylesheet $ StaticR teste_css
    sess <- lookupSession "_USER"
    toWidgetHead [hamlet|
        <meta name="keywords" content="Teste, Haskell">
    |]
    toWidgetHead [julius|
        function ola(){
            alert("Ola mundo!");
        }
    |]
    [whamlet|
        <h1>
            _{MsgHello}
        <a href=@{Pag1R}> _{MsgMenu1}
        <p>
            Uma parágrafo
        <button onclick="ola()">
            Clique!
        <br>
        $maybe sess' <- sess
            <form action=@{LogoutR} method=post>
                <input type="submit" value="Logout">
    |]


-- PARA USAR AS IMAGENS, EH NECESSARIO stack clean
-- E DEPOIS stack build para o Yesod criar as funcoes
-- baseadas no arquivos
-- haskell.jpg -> haskell_jpg

-- O lucius e cassius FICAM NO EXECUTAVEL
-- addStylesheet/addScript NAO deixa css/js no EXECUTAVEL
getTesteR :: Handler Html
getTesteR = do 
    defaultLayout $ do
        addStylesheet (StaticR teste_css)
        toWidgetHead [julius|
            function ola(){
                alert("Ola mundo!");
            }
        |]
        toWidgetHead [lucius|
            ul {
                list-style: none;
                font-family: Arial, Tahoma;
                height: 40px;
                width: 900px;
                background-color:#0c9;
                margin-left: auto;
                margin-right: auto;    
            }
            li {
                float:left;
                padding:12px;
                font-size:18px;
            }
            linha_topo {
                background-color:#c21d16;
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                height: 10px;
            }
            #header {
                height: 2500px;
                width: auto;
                background-color:#c21d16;
            }
            #logo {
                height: 130px;
                width: 932px;
                background-color:#0c9;
                margin-left: auto;
                margin-right: auto;
            }
            #menu_bg {
                height: 40px;
                width: auto;
                background: url(/static/menu_bg.jpg) repeat-x ;
                margin-left: auto;
                margin-right: auto;
            }
            #menu {
                height: 40px;
                width: 932px;
                margin-left: auto;
                margin-right: auto;
            }
            #content {
                height: 1200px;
                width: 932px;
                background-color:#0c9;
                margin-left: auto;
                margin-right: auto;
            }
            #sidebar-left {
                height: 1200px;
                width: 630px;
                background-color:#4e1253;
                float:left;
            }
            #sidebar-center {
                height: 1200px;
                width: 2px;
                background-color:#bb55c4;
                float:left;
            }
           #sidebar-right {
                height: 1200px;
                width: 300px;
                background-color:#121a53;
                float:left;
            }
            #footer {
                height: 50px;
                width: 932px;
                background-color:#c21d16;
                margin-left: auto;
                margin-right: auto;
                float:left;
                text-align:center;
            	font-size:12px;
            	color:#FFFFFF;
            }

            


            body { margin:0; padding:0; font-size:11px; line-height:16px; font-family: Arial, Tahoma;}
            a, a:visited { color:#283337; text-decoration:none;}
            a:hover {color:#c21d16; text-decoration:underline;}
            
            
        |]
        [whamlet|
        

            <linha_topo>   
            <div id="logo"><img src=@{StaticR header_jpg}>
            <div id="menu_bg"><div id="menu"> <ul>
                <li> 
                    <a href=@{Pag1R}> Página 1
                <li>
                    <a href=@{Pag2R}> Página 2
                <li>
                    <a href=@{Pag3R}> Página 3
            <br>

            
            <div id="content"><div id="sidebar-left"><h7>olooooolllldddeeee
            <div id="sidebar-center">
            <div id="sidebar-right">
            <div id="footer"><br>© Copyright 2017, Inc. Todos os direitos reservados.<br>
            
            <h1>
                _{MsgHello}
            <p>
                UM PARAGRAFOooo444o!
            <button onclick="ola()">
                Click
            
        |]

getPag1R :: Handler Html
getPag1R = do
    defaultLayout $ do
        [whamlet|
            <h1> 
                BEM-VINDO À Página 1
            
            <a href=@{TesteR}> 
                Voltar
        |]

getPag2R :: Handler Html
getPag2R = do
    defaultLayout $ do
        [whamlet|
            <h1> 
                BEM-VINDO À Página 2
            
            <a href=@{TesteR}> 
                Voltar
        |]

getPag3R :: Handler Html
getPag3R = do
    defaultLayout $ do
        [whamlet|
            <h1> 
                BEM-VINDO À Página 3
            
            <a href=@{TesteR}> 
                Voltar
        |]
{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
 
module Handler.Usuario where
import Yesod
import Foundation
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text

import Database.Persist.Postgresql

formUsu :: Form Usuario
formUsu = renderDivs $ Usuario <$>
             areq textField "Nome" Nothing <*>
             areq emailField "E-mail" Nothing <*>
             areq passwordField "Senha" Nothing 

formLogin :: Form (Text, Text)
formLogin = renderDivs $ (,) <$>
             areq emailField "E-mail" Nothing <*>
             areq passwordField "Senha" Nothing 

getUsuarioR :: Handler Html
getUsuarioR = do
            (widget, enctype) <- generateFormPost formUsu
            defaultLayout $ widgetForm UsuarioR enctype widget "Cadastro de Usuários"

postUsuarioR :: Handler Html
postUsuarioR = do
                ((result, _), _) <- runFormPost formUsu
                case result of
                    FormSuccess usu -> do
                       usuLR <- runDB $ insertBy usu
                       case usuLR of
                           Left _ -> redirect UsuarioR
                           Right _ -> defaultLayout [whamlet|
                                          <h1> #{usuarioNome usu} Inseridx com sucesso. 
                                      |]
                    _ -> redirect UsuarioR
                    
getLoginR :: Handler Html
getLoginR = do
            (widget, enctype) <- generateFormPost formLogin
            msgComMaybe <- getMessage
            defaultLayout $ do 
                [whamlet|
                    <linha_topo>
                    <div id="logo"><img src=@{StaticR header_jpg}>
                    
                    
                    $maybe msg <- msgComMaybe 
                        <h2>
                            #{msg}
                            <br><br><br>
                |]
                widgetForm LoginR enctype widget "Login page"
                
                [whamlet|
                    <div id="footer"><br>© Copyright 2017, Inc. Todos os direitos reservados.<br>
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
            	    background-color:#c21d16;
                    position: fixed;
                    bottom: 0;
                    left: 0;
                    right: 0;
                    height: 50px;
                    text-align:center;
                    font-size:12px;
                    }
                    
                    body { margin:0; padding:10px; font-size:11px; line-height:31px; font-family: Arial, Tahoma; text-align:center;}
                    a, a:visited { color:#283337; text-decoration:none;}
                    a:hover {color:#c21d16; text-decoration:underline;}
        	    |]



postLoginR :: Handler Html
postLoginR = do
                ((result, _), _) <- runFormPost formLogin
                case result of
                    FormSuccess ("root@root.com","root2") -> do
                        setSession "_USER" "admin"
                        redirect AdminR
                    FormSuccess (email,senha) -> do
                       temUsu <- runDB $ selectFirst [UsuarioEmail ==. email,UsuarioSenha ==. senha] []
                       case temUsu of
                           Nothing -> do
                               setMessage [shamlet| <p> Usuário ou senha inválido |]
                               redirect LoginR
                           Just _ -> do
                               setSession "_USER" email
                               defaultLayout [whamlet| Usuário autenticado!|]
                    _ -> redirect UsuarioR

getAdminR :: Handler Html
getAdminR = defaultLayout $ do
    [whamlet|
        <h1>
            Bem-vindo Rei dos Reis!!!!!!
    |]

postLogoutR :: Handler Html
postLogoutR = do
    deleteSession "_USER"
    redirect LoginR

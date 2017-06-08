{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
 
module Handler.Sala where
import Yesod
import Foundation
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text  

import Database.Persist.Postgresql


formSala :: Form Sala
formSala = renderDivs $ Sala 
                          <$> areq textField "Número: "     Nothing 
                          <*> areq textField "Descrição: "       Nothing

getCadastrarSalaR :: Handler Html
getCadastrarSalaR = do
        (widget, enctype) <- generateFormPost formSala
        defaultLayout $ do
            setTitle "FATEC - Cadastro de Salas"
            [whamlet|
                <linha_topo>
                <div id="logo"><img src=@{StaticR header_jpg}>
                <div id="menu_bg"><div id="menu"> <ul>
                    <li>
                        <a href=@{AdminR}> HOME
                    <li> 
                        <a href=@{ProfessorCadastrarR}> PROFESSOR
                    <li>
                        <a href=@{CadastrarDisciplinasR}> DISCIPLINA
                    <li>
                        <a href=@{CadastrarSalaR}> SALA
                    <li>
                        <a href=@{CadastrarHorarioR}> HORÁRIO
            <br>
            |]
            widgetForm CadastrarSalaR enctype widget "CADASTRAR SALA"
            
            [whamlet|
                <div id="footer">© Copyright 2017, Inc. Todos os direitos reservados.<br>
            |]
            
            toWidgetHead [lucius|
                    ul {
                    list-style: none;
                    font-family: Arial, Tahoma;
                    height: 40px;
                    width: 900px;
                    margin-left: auto;
                    margin-right: auto;    
                    }
                    
                    li {
                    float:left;
                    padding-left:28px;
                    padding-right:12px;
                    padding-top:6px;
                    padding-bottom:6px;
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
           

postCadastrarSalaR :: Handler Html    
postCadastrarSalaR = do
    ((result, _), _) <- runFormPost formSala
    case result of
        FormSuccess sala -> do
            runDB $ insert sala 
            defaultLayout [whamlet| 
               <h1> Sala #{salaNumero sala} inserida com sucesso. 
            |]
        _ -> redirect CadastrarSalaR
            

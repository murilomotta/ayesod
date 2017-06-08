{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
module Handler.Professor where

import Yesod
import Foundation -- Sem ele é necessário usar o HandlerT explicitamente
import Data.Text


formProfessor :: Form Professor
formProfessor = renderDivs $ Professor <$>
             areq textField "Nome" Nothing <*>
             areq textField "Apelido" Nothing

           
getProfessorCadastrarR :: Handler Html
getProfessorCadastrarR = do
        (widget, enctype) <- generateFormPost formProfessor
        defaultLayout $ do
            setTitle "FATEC - Cadastro Professor"          
            [whamlet|
                <linha_topo>
                <div id="logo"><img src=@{StaticR header_jpg}>
                <div id="menu_bg"><div id="menu">
                    <ul>
                        <li> 
                            <a href=@{ProfessorCadastrarR}> PROFESSOR
                        <li>
                            <a href=@{Pag2R}> Página 2
                        <li>
                            <a href=@{Pag3R}> Página 3
            |]

            
            widgetForm ProfessorCadastrarR enctype widget "Cadastrar Professor"
            
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
                    padding:6px;
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

                
           

postProfessorCadastrarR :: Handler Html    
postProfessorCadastrarR = do
    ((result, _), _) <- runFormPost formProfessor
    case result of
        FormSuccess professor -> do
            runDB $ insert professor 
            defaultLayout [whamlet| 
               <h1> #{professorNome professor} Inseridx com sucesso. 
            |]
        _ -> redirect ProfessorCadastrarR
            


        
        

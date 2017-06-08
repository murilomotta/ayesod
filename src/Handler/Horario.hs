{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
 
module Handler.Horario where
import Yesod
import Foundation
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text

import Database.Persist.Postgresql


formHorario :: Form Horario
formHorario = renderDivs $ Horario 
                          <$> areq textField "Período "    Nothing 
                          <*> areq (selectField discip) "Disciplina " Nothing
                          <*> areq (selectField profs) "Professor "       Nothing
                          <*> areq textField "Curso "      Nothing
                          <*> areq (selectField salas) "Sala "       Nothing
                          
salas = do
       entidades <- runDB $ selectList [] [Asc SalaNumero] 
       optionsPairs $ fmap (\ent -> (salaNumero $ entityVal ent, entityKey ent)) entidades
       
profs = do
       entidades <- runDB $ selectList [] [Asc ProfessorNome_exibe] 
       optionsPairs $ fmap (\ent -> (professorNome_exibe $ entityVal ent, entityKey ent)) entidades
       
discip = do
       entidades <- runDB $ selectList [] [Asc DisciplinaSigla] 
       optionsPairs $ fmap (\ent -> (disciplinaSigla $ entityVal ent, entityKey ent)) entidades


getCadastrarHorarioR :: Handler Html
getCadastrarHorarioR = do
        (widget, enctype) <- generateFormPost formHorario
        defaultLayout $ do
            setTitle "FATEC - Cadastro de Horários"
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
            widgetForm CadastrarHorarioR enctype widget "Cadastrar Horario"
            
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
           

postCadastrarHorarioR :: Handler Html    
postCadastrarHorarioR = do
    ((result, _), _) <- runFormPost formHorario
    case result of
        FormSuccess horario -> do
            runDB $ insert horario 
            defaultLayout [whamlet| 
               <h1> Horário inserido com sucesso. 
            |]
        _ -> redirect CadastrarSalaR
            

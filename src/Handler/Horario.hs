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
                          <$> areq textField "Periodo"    Nothing 
                          <*> areq (selectField discip) "Disciplina" Nothing
                          <*> areq (selectField profs) "Prof"       Nothing
                          <*> areq textField "Curso"      Nothing
                          <*> areq (selectField salas) "Sala"       Nothing
                          
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
            setTitle "Cadastro de Horários"
            [whamlet|
                <h1>
                    ola mundo
            |]
            widgetForm CadastrarHorarioR enctype widget "Horario"
           

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
            

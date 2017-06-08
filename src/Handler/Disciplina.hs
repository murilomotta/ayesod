{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
 
module Handler.Disciplina where
import Yesod
import Foundation
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text

import Database.Persist.Postgresql


formDisciplina :: Form Disciplina
formDisciplina = renderDivs $ Disciplina 
                          <$> areq textField "Sigla"      Nothing 
                          <*> areq textField "Descricao"  Nothing
                          <*> areq textField "Curso"      Nothing

getCadastrarDisciplinasR :: Handler Html
getCadastrarDisciplinasR = do
        (widget, enctype) <- generateFormPost formDisciplina
        defaultLayout $ do
            setTitle "Cadastro de disciplinas"
            [whamlet|
                <h1>
                    ola mundo
            |]
            widgetForm CadastrarDisciplinasR enctype widget "Disciplina"
           

postCadastrarDisciplinasR :: Handler Html    
postCadastrarDisciplinasR = do
    ((result, _), _) <- runFormPost formDisciplina
    case result of
        FormSuccess disciplina -> do
            runDB $ insert disciplina 
            defaultLayout [whamlet| 
               <h1> #{disciplinaSigla disciplina} inserida com sucesso. 
            |]
        _ -> redirect CadastrarDisciplinasR
            

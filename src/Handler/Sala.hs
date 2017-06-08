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
                          <$> areq textField "Numero"     Nothing 
                          <*> areq textField "Desc"       Nothing

getCadastrarSalaR :: Handler Html
getCadastrarSalaR = do
        (widget, enctype) <- generateFormPost formSala
        defaultLayout $ do
            setTitle "Cadastro de Salas"
            [whamlet|
                <h1>
                    ola mundo
            |]
            widgetForm CadastrarSalaR enctype widget "Sala"
           

postCadastrarSalaR :: Handler Html    
postCadastrarSalaR = do
    ((result, _), _) <- runFormPost formSala
    case result of
        FormSuccess sala -> do
            runDB $ insert sala 
            defaultLayout [whamlet| 
               <h1> #{salaNumero sala} inserida com sucesso. 
            |]
        _ -> redirect CadastrarSalaR
            

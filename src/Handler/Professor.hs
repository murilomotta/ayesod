{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
module Handler.Professor where

import Yesod
import Foundation -- Sem ele é necessário usar o HandlerT explicitamente
import Data.Text

getProfessorListarR    ::   Handler TypedContent
getProfessorListarR = undefined

getProfessorCadastrarR :: Handler TypedContent
getProfessorCadastrarR = undefined

postProfessorCadastrarR :: Handler TypedContent
postProfessorCadastrarR = undefined



-- retirado temporariamente - build falha no tipo form professor

{-
formProfessor :: Form Professor
formProfessor = renderDivs $ Professor <$>
             areq textField "Nome" Nothing

getProfessorCadastrarR :: Handler Html
getProfessorCadastrarR = do
        (widget, enctype) <- generateFormPost formProfessor
        defaultLayout $ do
            setTitle "Cadastro professor"
            [whamlet|
                <h1>
                    ola mundo
            |]
            widgetForm ProfessorCadastrarR enctype widget "Professor"
           

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
        
-}        


        
        

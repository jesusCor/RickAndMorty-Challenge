//
//  StoryboardUtils.swift
//  Rick and Morty Challenge
//
//  Created by Jesus Coronado on 29/01/2024.
//

import UIKit


class StoryboardUtils {
    
    private class func getViewController(storyboardName: String, vcId: String) -> UIViewController {
        let storyBoard = UIStoryboard.init(name: storyboardName, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: vcId)
    }
    
    class func getCharactersListVC() -> UIViewController {
        let vc = self.getViewController(
            storyboardName: StoryboardIds.mainStoryboard,
            vcId: StoryboardIds.charactersListVC
        )
        return vc
    }
    
    class func getCharacterDetailsVC() -> UIViewController {
        let vc = self.getViewController(
            storyboardName: StoryboardIds.mainStoryboard,
            vcId: StoryboardIds.characterDetailsVC
        )
        return vc
    }
    
}
